{ lib, fetchFromGitHub, curl, python3Packages, glibcLocales }:

python3Packages.buildPythonApplication rec {
  pname = "httpstat";
  version = "1.3.1";
  src = fetchFromGitHub {
    owner = "reorx";
    repo = pname;
    rev = version;
    sha256 = "sha256-zUdis41sQpJ1E3LdNwaCVj6gexi/Rk21IBUgoFISiDM=";
  };
  doCheck = false; # No tests
  buildInputs = [ glibcLocales ];
  runtimeDeps = [ curl ];

  LC_ALL = "en_US.UTF-8";

  meta = {
    description = "curl statistics made simple";
    mainProgram = "httpstat";
    homepage = "https://github.com/reorx/httpstat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nequissimus ];
  };
}
