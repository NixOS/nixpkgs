{ stdenv
, lib
, makeWrapper
, bundix
, common-updater-scripts
, nix-prefetch-github
, yarn
, yarn2nix
}:

stdenv.mkDerivation rec {
  name = "zammad-update-script";
  installPhase = ''
    mkdir -p $out/bin
    cp ${./update.sh} $out/bin/update.sh
    patchShebangs $out/bin/update.sh
    wrapProgram $out/bin/update.sh --prefix PATH : ${lib.makeBinPath buildInputs}
  '';
  phases = [ "installPhase" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    bundix
    common-updater-scripts
    nix-prefetch-github
    yarn
    yarn2nix
  ];

  meta = {
    maintainers = with lib.maintainers; [ n0emis ];
    description = "Utility to generate Nix expressions for Zammad's dependencies";
    platforms = lib.platforms.unix;
  };
}
