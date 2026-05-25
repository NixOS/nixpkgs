let
  pkgs = import ../../../.. {
    config = { };
    overlays = [ ];
  };

  inherit (pkgs)
    lib
    stdenvNoCC
    gitMinimal
    treefmt
    nixfmt
    ;
in

stdenvNoCC.mkDerivation {
  name = "test";
  src = lib.fileset.toSource {
    root = ./..;
    fileset = lib.fileset.unions [
      ../run.sh
      ./run.sh
      ./first.diff
      ./second.diff
    ];
  };
  nativeBuildInputs = [
    gitMinimal
    treefmt
    nixfmt
  ];
  patchPhase = ''
    patchShebangs .
  '';

  buildPhase = ''
    export HOME=$(mktemp -d)
    export PAGER=true
    git config --global user.email "Your Name"
    git config --global user.name "your.name@example.com"
    ./test/run.sh
  '';
  installPhase = ''
    touch $out
  '';
}
