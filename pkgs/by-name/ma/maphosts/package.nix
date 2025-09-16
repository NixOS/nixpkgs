{
  stdenv,
  lib,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
}:

let
  env = bundlerEnv {
    name = "maphosts-gems";
    inherit ruby;
    gemdir = ./.;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "maphosts";
  version = env.gems.maphosts.version;

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out/bin"
    ln -s "${env}/bin/maphosts" "$out/bin/maphosts"
  '';

  passthru.updateScript = bundlerUpdateScript "maphosts";

  meta = {
    description = "Small command line application for keeping your project hostnames in sync with /etc/hosts";
    homepage = "https://github.com/mpscholten/maphosts";
    changelog = "https://github.com/mpscholten/maphosts/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mpscholten
      nicknovitski
    ];
    platforms = lib.platforms.all;
    mainProgram = "maphosts";
  };
})
