{ lib
, stdenv
, fetchFromGitHub
, cmake
, libelf
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "dynamips";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JQJa3NZ9mQqqvuTzU7XmAr1WRB4zuLIwBx18OY3GbV8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libelf libpcap ];

  cmakeFlags = [ "-DDYNAMIPS_CODE=stable" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Cisco router emulator";
    longDescription = ''
      Dynamips is an emulator computer program that was written to emulate Cisco
      routers.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
