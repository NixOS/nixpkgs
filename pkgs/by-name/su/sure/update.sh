#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bundix curl jq nix-update nix-prefetch-github ruby_3_4
set -e
set -o pipefail

OWNER="we-promise"
REPO="sure"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
RUBY_ENV_DIR="${SCRIPT_DIR}/rubyEnv"
SOURCES_FILE="${SCRIPT_DIR}/sources.json"

old_version=$(jq -r .version "${SOURCES_FILE}" || echo -n "0.0.1")
version=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/${OWNER}/${REPO}/releases/latest" | jq -r ".tag_name")

echo "Updating to $version"

if [[ "${old_version}" == "${version}" ]]; then
  echo "Already up to date!"
  exit 0
fi

echo "Fetching source code"
JSON=$(nix-prefetch-github "${OWNER}" "${REPO}" --rev "refs/tags/${version}" 2>/dev/null)
HASH=$(echo "${JSON}" | jq -r .hash)

sources_tmp="$(mktemp)"
cat >"${sources_tmp}" <<EOF
{
  "owner": "${OWNER}",
  "repo": "${REPO}",
  "version": "${version}",
  "hash": "${HASH}"
}
EOF

echo "Downloading files from GitHub"
mkdir -p "${RUBY_ENV_DIR}"
for file in Gemfile Gemfile.lock; do
  curl -sL "https://raw.githubusercontent.com/${OWNER}/${REPO}/${version}/${file}" -o "${RUBY_ENV_DIR}/${file}"
done
RUBY_VERSION="$(curl -sL "https://raw.githubusercontent.com/${OWNER}/${REPO}/${version}/.ruby-version" | tr -d '[:space:]')"

# Avoid copying .ruby-version file
sed -i "s/^ruby file:.*$/ruby \">=${RUBY_VERSION}\"/" "${RUBY_ENV_DIR}/Gemfile"

# Bundix doesn't seem to support windows platform:
#   https://github.com/nix-community/bundix/issues/57
#   https://github.com/nix-community/bundix/pull/112
sed -i 's/, platforms: %i\[windows jruby\]//g' "${RUBY_ENV_DIR}/Gemfile"
sed -i 's/, platforms: %i\[mri windows\]//g' "${RUBY_ENV_DIR}/Gemfile"

# bundix and bundlerEnv fail with system-specific gems
(cd "${RUBY_ENV_DIR}" && BUNDLE_FORCE_RUBY_PLATFORM=true bundle lock)

bundix --lockfile="${RUBY_ENV_DIR}/Gemfile.lock" --gemfile="${RUBY_ENV_DIR}/Gemfile" --gemset="${RUBY_ENV_DIR}/gemset.nix"
nixfmt "${RUBY_ENV_DIR}/gemset.nix"

mv "${sources_tmp}" "${SOURCES_FILE}"
