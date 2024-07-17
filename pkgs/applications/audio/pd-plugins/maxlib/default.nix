{
  lib,
  stdenv,
  fetchFromGitHub,
  puredata,
}:

stdenv.mkDerivation rec {
  pname = "maxlib";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "electrickery";
    repo = "pd-maxlib";
    rev = "v${version}";
    sha256 = "10w9qfgn26lj3zqjksf2r1wsjpf5xy4dx22jay9l6idy9q62mxsn";
  };

  buildInputs = [ puredata ];

  hardeningDisable = [ "format" ];

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    mv $out/lib/pd-externals/maxlib/ $out
    rm -rf $out/local/
    rm -rf $out/lib/
  '';

  meta = {
    description = "A library of non-tilde externals for puredata, by Miller Puckette";
    homepage = "http://puredata.info/downloads/maxlib";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
