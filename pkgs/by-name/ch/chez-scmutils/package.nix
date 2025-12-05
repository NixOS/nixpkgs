{
  stdenv,
  lib,
  fetchFromGitHub,
  chez,
  chez-srfi,
  chez-mit,
}:

stdenv.mkDerivation rec {
  pname = "chez-scmutils";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "fedeinthemix";
    repo = "chez-scmutils";
    rev = "v${version}";
    sha256 = "sha256-y2ug7GfmkJC6jddgB8YllsumjmGxFJxTGTpPf1Vcs/s=";
  };

  buildInputs = [
    chez
    chez-srfi
    chez-mit
  ];

  lib-path = "lib/csv${lib.versions.majorMinor chez.version}-site";

  makeFlags = [
    "CHEZ=${lib.getExe chez}"
    "PREFIX=$(out)"
    "CHEZSCHEMELIBDIRS=${chez-srfi}/${lib-path}:${chez-mit}/${lib-path}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Port of the 'MIT Scmutils' library to Chez Scheme";
    homepage = "https://github.com/fedeinthemix/chez-scmutils/";
    maintainers = [ maintainers.jitwit ];
    license = licenses.gpl3;
  };

}
