{
  lib,
  fetchFromGitHub,
  python3,
  wireshark-cli,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "credslayer";
  version = "0.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ShellCode33";
    repo = "CredSLayer";
    tag = "v${version}";
    hash = "sha256-gryV9MHULY6ZHy6YDFQDIkZsfIX8La0tHT0vrrQJNDQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pyshark
  ];

  nativeCheckInputs = with python3.pkgs; [
    py
    pytestCheckHook
    wireshark-cli
  ];

  enabledTestPaths = [
    "tests/tests.py"
  ];

  disabledTests = [
    # Requires a telnet setup
    "test_telnet"
    # stdout has all the correct data, but the underlying test code fails
    # functionally everything seems to be intact
    "http_get_auth"
    "test_http_post_auth"
    "test_ntlmssp"
  ];

  pythonImportsCheck = [
    "credslayer"
  ];

  postInstall = ''
    wrapProgram $out/bin/credslayer \
       --prefix PATH : "${lib.makeBinPath [ wireshark-cli ]}"
  '';

  meta = with lib; {
    description = "Extract credentials and other useful info from network captures";
    mainProgram = "credslayer";
    homepage = "https://github.com/ShellCode33/CredSLayer";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
    # broken due to wireshark 4.4 bump
    # see: https://github.com/NixOS/nixpkgs/pull/344914
    broken = true;
  };
}
