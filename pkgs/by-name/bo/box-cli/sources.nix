# NOTE:
# To update: run `nix-prefetch-url` for each platform URL and convert to SRI hash.
# URLs: https://ascii.dev/api/box/cli/download?platform={platform}&channel=ascii-prod
# Last updated: 2026-06-26
{
  x86_64-linux = {
    url = "https://ascii.dev/api/box/cli/download?platform=linux-x64&channel=ascii-prod";
    hash = "sha256-DWQNenz/pmFVH5QM554lBk6+RwgOCjCBe7p+ZkHADTI=";
  };
  aarch64-linux = {
    url = "https://ascii.dev/api/box/cli/download?platform=linux-arm64&channel=ascii-prod";
    hash = "sha256-V2Sk6C1ZTRWlYQ2bVQTvK6PU8BkBPkmJMjUAo2Ul6+Q=";
  };
  x86_64-darwin = {
    url = "https://ascii.dev/api/box/cli/download?platform=darwin-x64&channel=ascii-prod";
    hash = "sha256-QI+ecq0O4dkKqdIvkONcYdXsS+EQLFIU35ulKGNSCRE=";
  };
  aarch64-darwin = {
    url = "https://ascii.dev/api/box/cli/download?platform=darwin-arm64&channel=ascii-prod";
    hash = "sha256-cyjMUGkWfNOggvtBfVqCijmcAj0P2SuFQORwg9EWbn0=";
  };
}
