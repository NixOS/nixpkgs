{ lib, stdenv, fetchFromGitHub, cmake, libelf, libpcap }:

stdenv.mkDerivation rec {
  pname = "dynamips";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pvdqs6kjz0x0wqb5f1k3r25dg82wssm7wz4psm0m6bxsvf5l0i5";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libelf libpcap ];

  cmakeFlags = [ "-DDYNAMIPS_CODE=stable" ];

  meta = with lib; {
    description = "A Cisco router emulator";
    longDescription = ''
      Dynamips is an emulator computer program that was written to emulate Cisco
      routers.
    '';
    inherit (src.meta) homepage;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
