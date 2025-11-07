{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  xorg,
  libXext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highlight-pointer";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "swillner";
    repo = "highlight-pointer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Og09/RmLWtzVAMs79Z4eDuXWg4w2kZfXyX8K7CowFaU=";
  };

  buildInputs = [
    libX11
    libXext
    xorg.libXi
    xorg.libXfixes
  ];

  installPhase = ''
    runHook preInstall

    install -m 555 -D highlight-pointer $out/bin/highlight-pointer

    runHook postInstall
  '';

  meta = with lib; {
    description = "Highlight mouse pointer/cursor using a dot";
    homepage = "https://github.com/swillner/highlight-pointer";
    changelog = "https://github.com/swillner/highlight-pointer/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ DCsunset ];
    mainProgram = "highlight-pointer";
  };
})
