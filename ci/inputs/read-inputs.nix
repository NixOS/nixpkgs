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
in

lockfile:
let
  lock = builtins.fromJSON (builtins.readFile lockfile);
in
builtins.mapAttrs (_: node: fetchNode lock.nodes.${node}.locked) lock.nodes.${lock.root}.inputs
