{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "passphraseme";
  version = "0.1.5";

  src = fetchFromGitHub {
    repo = pname;
    rev = version;
    owner = "micahflee";
    sha256 = "sha256-WBJb0ecO9dRQocPPCCzlDWR00RV9BqplZiw13WWdfYI=";
  };

  meta = with lib; {
    description = "A quick and simple cryptographically secure script to generate high entropy passphrases using the Electronic Frontier Foundation's wordlists";
    homepage = "https://github.com/micahflee/passphraseme";
    license = licenses.gpl3;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
