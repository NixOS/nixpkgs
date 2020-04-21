{ lib, fetchurl }:

{ owner, repo, tag, asset
, name ? "source"
, githubBase ? "github.com"
, ... }@args:

# don't do fetchFromGitHub's job
assert (asset != "${tag}.zip" && asset != "${tag}.tar.gz");

let
  baseUrl = "https://${githubBase}/${owner}/${repo}";
  passthruAttrs = removeAttrs args [ "owner" "repo" "tag" "githubBase" "asset" ];
  fetchArgs = {
    inherit name;
    url = "${baseUrl}/releases/download/${tag}/${asset}";
    meta.homepage = baseUrl;
  } // passthruAttrs;
in fetchurl fetchArgs
