{
  stdenv,
  lib,
  fetchFromGitHub,
  chez,
  chez-srfi,
}:

stdenv.mkDerivation rec {
  pname = "chez-mit";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "fedeinthemix";
    repo = "chez-mit";
    rev = "v${version}";
    sha256 = "sha256-TmoLA0zLETKE+PsrGS5dce9xLQUIKwSNixRSVjbrOlk=";
  };

  buildInputs = [
    chez
    chez-srfi
  ];

  makeFlags = [
    "CHEZ=${lib.getExe chez}"
    "PREFIX=$(out)"
    "CHEZSCHEMELIBDIRS=${chez-srfi}/lib/csv${lib.versions.majorMinor chez.version}-site"
  ];

  doCheck = false;

  meta = with lib; {
    description = "MIT/GNU Scheme compatibility library for Chez Scheme";
    homepage = "https://github.com/fedeinthemix/chez-mit/";
    maintainers = [ maintainers.jitwit ];
    license = licenses.gpl3Plus;
    broken = stdenv.hostPlatform.isDarwin;
  };

}
