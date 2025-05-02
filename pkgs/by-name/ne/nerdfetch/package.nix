{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nerdfetch";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "ThatOneCalculator";
    repo = "NerdFetch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mSRS7MUgaa14mgPYkbC4O1/gXxbyDKOiVCRgoh8He/c=";
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

  meta = with lib;{
    description = "A POSIX *nix (Linux, macOS, Android, *BSD, etc) fetch script using Nerdfonts";
    homepage = "https://github.com/ThatOneCalculator/NerdFetch";
    maintainers = with maintainers; [ ByteSudoer ];
    license = licenses.mit;
    mainProgram = "nerdfetch";
    platforms = platforms.unix;
  };
})
