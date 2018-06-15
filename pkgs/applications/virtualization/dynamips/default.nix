{ stdenv, fetchFromGitHub, cmake, libelf, libpcap }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dynamips";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jrwvrpl61rqbjjphv8v7ryhdwfjrpps76dbvkpl43hpn5hqqis2";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libelf libpcap ];

  cmakeFlags = [ "-DDYNAMIPS_CODE=stable" ];

  meta = with stdenv.lib; {
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
