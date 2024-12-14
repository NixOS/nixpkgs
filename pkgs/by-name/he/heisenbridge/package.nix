{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-1ljRwJYdIKWuTRDnH2EcZ6zQp4o4Rx+/9OqjX6J4gDA=";
  };

  postPatch = ''
    echo "${version}" > heisenbridge/version.txt
  '';

  propagatedBuildInputs = with python3.pkgs; [
    irc
    ruamel-yaml
    mautrix
    python-socks
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Bouncer-style Matrix-IRC bridge";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
    mainProgram = "heisenbridge";
  };
}
