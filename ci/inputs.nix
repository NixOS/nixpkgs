# This file provides access to the CI-locked flake inputs, without evaluating the flake.
# Instead, it directly imports the JSON lockfile and returns the root node's inputs.
let
  # The `fetchTree` primop is experimental, so provide a compatible fallback
  fetchNode =
    builtins.fetchTree or (
      info:
      if info.type == "github" then
        {
          inherit (info) rev narHash lastModified;
          outPath = fetchTarball {
            url = "https://api.${info.host or "github.com"}/repos/${info.owner}/${info.repo}/tarball/${info.rev}";
            sha256 = info.narHash;
          };
        }
      else if info.type == "tarball" then
        {
          outPath = fetchTarball {
            inherit (info) url;
            sha256 = info.narHash;
          };
        }
      else if info.type == "path" then
        {
          outPath = builtins.path {
            path = info.path;
            sha256 = info.narHash;
          };
          inherit (info) narHash;
        }
      else
        throw "nixpkgs-ci: unsupported input type '${info.type}'"
    );
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
in
builtins.mapAttrs (_: node: fetchNode lock.nodes.${node}.locked) lock.nodes.${lock.root}.inputs
