{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libelf,
  libpcap,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "dynamips";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+h+WsZ/QrDd+dNrR6CJb2uMG+vbUvK8GTxFJZOxknL0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libelf
    libpcap
  ];

  cmakeFlags = [ "-DDYNAMIPS_CODE=stable" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Cisco router emulator";
    longDescription = ''
      Dynamips is an emulator computer program that was written to emulate Cisco
      routers.
    '';
    license = licenses.gpl2Plus;
    mainProgram = "dynamips";
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
