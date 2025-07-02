{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.15.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = "heisenbridge";
    tag = "v${version}";
    sha256 = "sha256-wH3IZcY4CtawEicKCkFMh055SM0chYHsPKxYess9II0=";
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Bouncer-style Matrix-IRC bridge";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
    mainProgram = "heisenbridge";
  };
}
