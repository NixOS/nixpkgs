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
  version = "0-unstable-2025-07-07";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qdl";
    rev = "cd3272350328185b1d4f7de08fdecf38f8fd31be";
    hash = "sha256-Q4XcnBfr4wk2Kt0iLwF8niYoofg1YuXUehkg3G/gNOo=";
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
