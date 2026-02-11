{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nerdfetch";
  version = "8.5.2";

  src = fetchFromGitHub {
    owner = "ThatOneCalculator";
    repo = "NerdFetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QllhAcG0Ocp1qhXrw/3SbMoUzVja8/RzzKhyqO1lpcM=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
      cp $src/nerdfetch $out/bin
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "POSIX *nix (Linux, macOS, Android, *BSD, etc) fetch script using Nerdfonts";
    homepage = "https://github.com/ThatOneCalculator/NerdFetch";
    changelog = "https://github.com/ThatOneCalculator/NerdFetch/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ ByteSudoer ];
    license = lib.licenses.mit;
    mainProgram = "nerdfetch";
    platforms = lib.platforms.unix;
  };
})
