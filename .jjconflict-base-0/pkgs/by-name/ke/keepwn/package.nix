{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "keepwn";
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Orange-Cyberdefense";
    repo = "KeePwn";
    tag = version;
    hash = "sha256-z2+l7zOexcqbwkrdmB3EcYIjnGlproINF51Pcpp7Nz4=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    chardet
    impacket
    lxml
    pefile
    pykeepass
    python-magic
    termcolor
  ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mv $out/bin/KeePwn $out/bin/$pname
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "keepwn" ];

  meta = with lib; {
    description = "Tool to automate KeePass discovery and secret extraction";
    homepage = "https://github.com/Orange-Cyberdefense/KeePwn";
    changelog = "https://github.com/Orange-Cyberdefense/KeePwn/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "keepwn";
  };
}
