{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  libelf,
  libpcap,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "dynamips";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "dynamips";
    tag = "v${version}";
    hash = "sha256-+h+WsZ/QrDd+dNrR6CJb2uMG+vbUvK8GTxFJZOxknL0=";
  };

  patches = [
    # https://github.com/GNS3/dynamips/issues/305
    (fetchpatch {
      name = "cmake4-compat.patch";
      url = "https://github.com/GNS3/dynamips/commit/fdbbb7d3887eaa5b024bbcbcc14215f420a7e989.patch";
      hash = "sha256-CbiPGrIqn9KGnZEPUw7LiH8dkqzjfu4UxW1f7Fzbwro=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libelf
    libpcap
  ];

  cmakeFlags = [
    (lib.cmakeFeature "DYNAMIPS_CODE" "stable")
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cisco router emulator";
    longDescription = ''
      Dynamips is an emulator computer program that was written to emulate Cisco
      routers.
    '';
    homepage = "https://github.com/GNS3/dynamips";
    changelog = "https://github.com/GNS3/dynamips/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "dynamips";
    maintainers = with lib.maintainers; [
      anthonyroussel
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
