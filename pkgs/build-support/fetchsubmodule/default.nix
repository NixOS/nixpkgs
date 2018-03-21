{ path # the root of nixpkgs
}: let
  # rather than figuring out how to read this information from Nix, I just use the prepare_sources.
  sources = builtins.fromJSON (builtins.readFile (path + "/sources.json"));
in
relpath:
let
  submodule = sources."sources/${relpath}";
in
if submodule.initialized
then builtins.fetchGit submodule.path
else builtins.fetchGit { url = submodule.url; rev = submodule.hash; }
