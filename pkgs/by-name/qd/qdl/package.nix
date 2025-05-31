{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libxml2,
  systemd,
  libusb1,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdl";
  version = "0-unstable-2025-03-19";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qdl";
    rev = "30ac3a8abcfb0825157185f11e595d0c7562c0df";
    hash = "sha256-5ZV39whIm8qJIBLNdAsR2e8+f0jYjwE9dGNgh6ARPUY=";
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

  meta = {
    homepage = "https://github.com/linux-msm/qdl";
    description = "Tool for flashing images to Qualcomm devices";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      muscaln
      anas
    ];
    platforms = lib.platforms.linux;
    mainProgram = "qdl";
  };

  passthru.updateScript = unstableGitUpdater { };
})
