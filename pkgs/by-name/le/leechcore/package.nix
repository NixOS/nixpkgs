{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "leechcore";
  version = "2.23";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ufrisk";
    repo = "leechcore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gA/sN4Z8r91aE9WZABwSH6qxlyOMDLYEBTXjYVG5joE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libusb1
    python3
  ];

  buildPhase = ''
    runHook preBuild
    make -C leechcore
    make -C leechcorepyc
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 files/leechcore.so -t "$out/lib"
    install -Dm644 leechcore/leechcore.h -t "$out/include"
    install -Dm755 files/leechcorepyc.so -t "$out/lib"
    install -Dm644 leechcorepyc/leechcorepyc.h -t "$out/include"
    runHook postInstall
  '';

  meta = {
    description = "Physical memory acquisition library";
    homepage = "https://github.com/ufrisk/LeechCore/";
    changelog = "https://github.com/ufrisk/LeechCore/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
