{
  lib,
  multiStdenv,
  fetchFromGitHub,
  libx11,
  libxxf86vm,
  xorgproto,
  unstableGitUpdater,
}:

multiStdenv.mkDerivation (finalAttrs: {
  pname = "hax11";
  version = "0-unstable-2026-10-11";

  src = fetchFromGitHub {
    owner = "CyberShadow";
    repo = "hax11";
    rev = "6a0e2fc20ffef4d67ef6bf06d8d15afbae130898";
    hash = "sha256-EunqOSuVkLZKCCshbrmtLldzGvstU+LbhqFC+kFmXsg=";
  };

  outputs = [
    "out"
    "doc"
  ];

  buildInputs = [
    libx11
    libxxf86vm
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cybershadow ];
    platforms = lib.platforms.linux;
  };
})
