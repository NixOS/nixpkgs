{
  lib,
  writeShellApplication,
  jq,
  curl,
  nix-prefetch-git,
  common-updater-scripts,

  owner,
  repo,
  tag,
}:

lib.getExe (writeShellApplication {
  name = "nzp-updater";
  runtimeInputs = [
    jq
    curl
    nix-prefetch-git
    common-updater-scripts
  ];
  text = ''
    release_info=$(curl -L "https://api.github.com/repos/${owner}/${repo}/releases/tags/${tag}")
    prefetch=$(nix-prefetch-git "https://github.com/${owner}/${repo}" --rev "${tag}")

    version=$(echo "$release_info" | jq -r '"0-unstable-\(.name | ltrimstr("Automated Release "))"')
    rev=$(echo "$prefetch" | jq -r ".rev")
    hash=$(echo "$prefetch" | jq -r ".hash")

    update-source-version "$UPDATE_NIX_ATTR_PATH" "$version" "$hash" --rev="$rev"
  '';
})
