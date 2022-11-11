{ lib
, stdenv
, fetchFromGitHub
, cmake
, libelf
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "dynamips";
  version = "0.2.22";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fjjjdaxlw1k95kyq73fndn21qfhrm4cn79av0i4sn7anhg8m83f";
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
