{ stdenv, fetchFromGitHub, puredata }:

stdenv.mkDerivation rec {
  pname = "cyclone";
  version = "0.3beta-2";

  src = fetchFromGitHub {
    owner = "porres";
    repo = "pd-cyclone";
    rev = "cyclone${version}";
    sha256 = "192jrq3bdsv626js1ymq10gwp9wwcszjs63ys6ap9ig8xdkbhr3q";
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

  meta = {
    description = "A library of PureData classes, bringing some level of compatibility between Max/MSP and Pd environments";
    homepage = "http://puredata.info/downloads/cyclone";
    license = stdenv.lib.licenses.tcltk;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
