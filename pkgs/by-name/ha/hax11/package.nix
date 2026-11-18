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
  version = "0-unstable-2026-11-12";

  src = fetchFromGitHub {
    owner = "CyberShadow";
    repo = "hax11";
    rev = "ab1e1e07f19284b4999e0eaab638a0f2c7daccc9";
    hash = "sha256-o4pMBzS/W7NI+P5ihIFHuClCZuHoa0+mmjxjTGa4m+g=";
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
