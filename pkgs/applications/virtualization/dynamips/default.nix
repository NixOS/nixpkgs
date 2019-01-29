{ stdenv, fetchFromGitHub, cmake, libelf, libpcap }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dynamips";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x63m37vjyp57900x09gfvw02cwg85b33918x7fjj9x37wgmi5qf";
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
