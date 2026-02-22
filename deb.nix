let
  pkgs = import ./default.nix {};
  vm = pkgs.vmTools.diskImageFuns.ubuntu2204x86_64 {};
  args = {
    diskImage = vm;
    diskImageFormat = "qcow2";
    src = pkgs.ncurses.src;
    name = "ncurses-deb";
    buildInputs = [];
    meta.description = "No descr";
  };
in
  pkgs.releaseTools.debBuild args
