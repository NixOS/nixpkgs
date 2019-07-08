{ stdenv, fetchFromGitHub, cmake, libelf, libpcap }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dynamips";
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = "1841h0m0k0p3c3ify4imafjk7jigcj2zlr8rn3iyp7jnafkxqik7";
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
