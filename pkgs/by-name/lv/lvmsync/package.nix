{
  lib,
  stdenv,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "lvmsync";
  version = (import ./gemset.nix).${pname}.version;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase =
    let
      env = bundlerEnv {
        name = "${pname}-${version}-gems";
        ruby = ruby;
        gemfile = ./Gemfile;
        lockfile = ./Gemfile.lock;
        gemset = ./gemset.nix;
      };
    in
    ''
      mkdir -p $out/bin
      makeWrapper ${env}/bin/lvmsync $out/bin/lvmsync
    '';

  passthru.updateScript = bundlerUpdateScript "lvmsync";

  meta = {
    description = "Optimised synchronisation of LVM snapshots over a network";
    mainProgram = "lvmsync";
    homepage = "https://theshed.hezmatt.org/lvmsync/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      jluttine
      nicknovitski
    ];
  };

}
