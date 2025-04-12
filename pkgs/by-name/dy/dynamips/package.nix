{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
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
    rev = "refs/tags/v${version}";
    hash = "sha256-+h+WsZ/QrDd+dNrR6CJb2uMG+vbUvK8GTxFJZOxknL0=";
  };

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

  meta = with lib; {
    description = "Cisco router emulator";
    longDescription = ''
      Dynamips is an emulator computer program that was written to emulate Cisco
      routers.
    '';
    homepage = "https://github.com/GNS3/dynamips";
    changelog = "https://github.com/GNS3/dynamips/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    mainProgram = "dynamips";
    maintainers = with maintainers; [
      primeos
      anthonyroussel
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
