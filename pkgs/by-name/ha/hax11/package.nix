{
  lib,
  multiStdenv,
  fetchFromGitHub,
  libX11,
  libXxf86vm,
  xorgproto,
  unstableGitUpdater,
}:

multiStdenv.mkDerivation (finalAttrs: {
  pname = "hax11";
  version = "0-unstable-2025-04-29";

  src = fetchFromGitHub {
    owner = "CyberShadow";
    repo = "hax11";
    rev = "d82bf3ba655c1a823b77a9a47f30657c9a32c1fe";
    hash = "sha256-Ykl/RdGRHmM+xko5a9tR2G1yFaY/Xq+BEoeXaLd39RQ=";
  };

  outputs = [
    "out"
    "doc"
  ];

  buildInputs = [
    libX11
    libXxf86vm
    xorgproto
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 lib32/hax11.so -t $out/lib32/
    install -Dm644 lib64/hax11.so -t $out/lib64/
    install -Dm644 README.md -t $doc/share/doc/hax11/

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    homepage = "https://github.com/CyberShadow/hax11";
    description = "Hackbrary to Hook and Augment X11 protocol calls";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ cybershadow ];
    platforms = lib.platforms.linux;
  };
})
