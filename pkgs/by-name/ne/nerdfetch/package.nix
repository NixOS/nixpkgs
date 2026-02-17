{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nerdfetch";
  version = "8.5.1";

  src = fetchFromGitHub {
    owner = "ThatOneCalculator";
    repo = "NerdFetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wt/VpieLuS8cAUlpCdiFysdrjXwgGZ436eMUycTl0S4=";
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
    changelog = "https://github.com/ThatOneCalculator/NerdFetch/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ ByteSudoer ];
    license = lib.licenses.mit;
    mainProgram = "nerdfetch";
    platforms = lib.platforms.unix;
  };
})
