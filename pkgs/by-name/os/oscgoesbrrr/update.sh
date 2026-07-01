#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch jq git

dirname="$(dirname "$0")"

latest_release=$(curl --silent https://api.github.com/repos/OscToys/OscGoesBrrr/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release")
version="${version#*v}"
old_version="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion oscgoesbrrr" | tr -d '"')"

if [ "$old_version" = "$version" ]; then
    printf 'No new version available, current: %s\n' "$version"
    exit 0
else
    printf 'Updating from version %s to %s\n' "$old_version" "$version"
    sed -i "s/version = \"$old_version\"/version = \"$version\"/" "$dirname/package.nix"
fi

src_hash=$(nix-prefetch-url --unpack "https://github.com/OscToys/OscGoesBrrr/archive/refs/tags/v${version}.tar.gz")
src_hash_sri=$(nix hash convert --hash-algo sha256 --to sri "sha256:$src_hash")

pnpm_hash=$(nix build --impure --no-link --expr "
  let pkgs = import <nixpkgs> {};
  in pkgs.fetchPnpmDeps {
    pname = \"oscgoesbrrr\";
    version = \"${version}\";
    src = pkgs.fetchFromGitHub {
      owner = \"OscToys\";
      repo = \"OscGoesBrrr\";
      rev = \"v${version}\";
      hash = \"${src_hash_sri}\";
    };
    pnpm = pkgs.pnpm_10.override { nodejs = pkgs.nodejs_24; };
    fetcherVersion = 3;
    hash = \"\";
  }
" 2>&1 | grep "got:" | awk '{print $2}')

cat > "${dirname}/sources.nix" <<EOF
{
  src = {
    rev = "v${version}";
    hash = "${src_hash_sri}";
  };
  pnpmDeps = {
    hash = "${pnpm_hash}";
  };
}
EOF

git add "${dirname}/package.nix" "${dirname}/sources.nix"
git commit -m "oscgoesbrrr: ${old_version} -> ${version}"
