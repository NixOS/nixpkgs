{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nerdfetch";
  version = "8.4.2";

  src = fetchFromGitHub {
    owner = "ThatOneCalculator";
    repo = "NerdFetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G1BWggVPxpIKK82pKHD4Jxyis4CY156Jox2/xHRQfrI=";
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

  meta = with lib; {
    description = "POSIX *nix (Linux, macOS, Android, *BSD, etc) fetch script using Nerdfonts";
    homepage = "https://github.com/ThatOneCalculator/NerdFetch";
    changelog = "https://github.com/ThatOneCalculator/NerdFetch/releases/tag/${finalAttrs.version}";
    maintainers = with maintainers; [ ByteSudoer ];
    license = licenses.mit;
    mainProgram = "nerdfetch";
    platforms = platforms.unix;
  };
})
