{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
  inherit (python3Packages) buildPythonApplication pythonOlder;

in
buildPythonApplication rec {
  pname = "pwgen-secure";
  version = "0.9.1";
  format = "setuptools";

  # it needs `secrets` which was introduced in 3.6
  disabled = pythonOlder "3.6";

  # GH is newer than Pypi and contains both library *and* the actual program
  # whereas Pypi only has the library
  src = fetchFromGitHub {
    owner = "mjmunger";
    repo = "pwgen_secure";
    rev = "v${version}";
    sha256 = "15md5606hzy1xfhj2lxmc0nvynyrcs4vxa5jdi34kfm31rdklj28";
  };

  postPatch = ''
    shareDir=$out/share/${pname}

    substituteInPlace spwgen.py \
      --replace-fail ' \ ' ' \\ '

    substituteInPlace pwgen_secure/rpg.py \
      --replace-fail "os.path.join(path, 'words.txt')" "os.path.join('$shareDir', 'words.txt')"
  '';

  propagatedBuildInputs = with python3Packages; [ docopt ];

  postInstall = ''
    install -Dm555 spwgen.py $out/bin/spwgen
    install -Dm444 pwgen_secure/words.txt -t $shareDir
  '';

  # there are no checks
  doCheck = false;

  meta = with lib; {
    description = "Secure password generation library to replace pwgen";
    homepage = "https://github.com/mjmunger/pwgen_secure/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "spwgen";
  };
}
