{
  lib,
  stdenv,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lvmsync";
  version = (import ./gemset.nix).${finalAttrs.pname}.version;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase =
    let
      env = bundlerEnv {
        name = "${finalAttrs.pname}-${finalAttrs.version}-gems";
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
})
