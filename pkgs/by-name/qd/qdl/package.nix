{

  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libxml2,
  libusb1,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdl";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8jkuSNK7xTBUkBWzh766zKOlh+7pTr+e0xT1w3xifsw=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace-fail 'pkg-config' '${stdenv.cc.targetPrefix}pkg-config'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxml2
    libusb1
  ];

  makeFlags = [
    "VERSION=${finalAttrs.src.rev}"
    "prefix=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/linux-msm/qdl";
    description = "Tool for flashing images to Qualcomm devices";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      muscaln
      anas
      numinit
    ];
    platforms = lib.platforms.linux;
    mainProgram = "qdl";
  };
})
