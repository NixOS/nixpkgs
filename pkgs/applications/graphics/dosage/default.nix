{ stdenv, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  pname = "dosage";
  version = "2018.04.08";
  PBR_VERSION = version;

  src = fetchFromGitHub {
    owner = "webcomics";
    repo = "dosage";
    rev = "b2fdc13feb65b93762928f7e99bac7b1b7b31591";
    sha256 = "1p6vllqaf9s6crj47xqp97hkglch1kd4y8y4lxvzx3g2shhhk9hh";
  };
  buildInputs = with pythonPackages; [ pytest responses ];
  propagatedBuildInputs = with pythonPackages; [ colorama lxml requests pbr ];

  disabled = pythonPackages.pythonOlder "3.3";

  checkPhase = ''
    py.test tests/
  '';

  meta = {
    description = "A comic strip downloader and archiver";
    homepage = https://dosage.rocks/;
    license = stdenv.lib.licenses.mit;
  };
}
