{ lib, stdenv, fetchFromGitHub, puredata }:

stdenv.mkDerivation rec {
  pname = "cyclone";
  version = "0.7-0";

  src = fetchFromGitHub {
    owner = "porres";
    repo = "pd-cyclone";
    rev = "cyclone_${version}";
    sha256 = "C+zs+xNyv6bV1LIZT2E7Yg0fyHADcHze3VpmmW/YJWg=";
  };

  buildInputs = [ puredata ];

  makeFlags = [
    "pdincludepath=${puredata}/include/pd"
    "prefix=$(out)"
  ];

  postInstall = ''
    mv "$out/lib/pd-externals/cyclone" "$out/"
    rm -rf $out/lib
  '';

  meta = with lib; {
    broken = true;
    description = "A library of PureData classes, bringing some level of compatibility between Max/MSP and Pd environments";
    homepage = "http://puredata.info/downloads/cyclone";
    license = licenses.tcltk;
    maintainers = [ maintainers.magnetophon maintainers.carlthome ];
    platforms = platforms.linux;
  };
}
