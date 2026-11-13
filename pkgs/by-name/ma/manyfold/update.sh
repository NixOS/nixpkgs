#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update bundix bundler pkgs.nixfmt yarn-berry_3.yarn-berry-fetcher nix-prefetch-git ruby_3_4

set -eux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-manyfold}"
HOME=$(mktemp -d)

# Update version and source
nix-update "$UPDATE_NIX_ATTR_PATH" --src-only || true

src=$(nix-build --no-link -A "$UPDATE_NIX_ATTR_PATH".src)

pushd "$HOME"
# Update yarn deps
yarn-berry-fetcher missing-hashes "$src/yarn.lock" >"$SCRIPT_DIR/missing-hashes.json"

# Update ruby deps
cp --recursive --no-preserve=mode "$src"/. .
BUNDLE_FORCE_RUBY_PLATFORM=true bundle lock
ruby -rbundix -rbundix/commandline -e '
cli = Bundix::CommandLine.new
gemset = cli.build_gemset
def clean_nils(obj)
  if obj.is_a?(Hash)
    obj.transform_values { |v| clean_nils(v) }
  elsif obj.is_a?(Array)
    obj.compact.map { |v| clean_nils(v) }
  else
    obj
  end
end
gemset = clean_nils(gemset)
cli.save_gemset(gemset)
'
nixfmt gemset.nix
install -m 0644 -D ./{Gemfile,Gemfile.lock,gemset.nix} -t "$SCRIPT_DIR"
popd

# Update dependency hashes
nix-update "$UPDATE_NIX_ATTR_PATH" --version skip || true
