{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxi,
  libxfixes,
  libxext,
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
    libx11
    libxext
    libxi
    libxfixes
  ];

  installPhase = ''
    runHook preInstall

    install -m 555 -D highlight-pointer $out/bin/highlight-pointer

    runHook postInstall
  '';

  meta = {
    description = "Highlight mouse pointer/cursor using a dot";
    homepage = "https://github.com/swillner/highlight-pointer";
    changelog = "https://github.com/swillner/highlight-pointer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ DCsunset ];
    mainProgram = "highlight-pointer";
  };
})
