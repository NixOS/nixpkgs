{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "charge-lnd";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "accumulator";
    repo = pname;
    rev = "v${version}";
    sha256 = "uiXmLdQAglgLxOX6IoF1iNZvje4EM7Tr25Okx9TPyzI=";
  };

  propagatedBuildInputs = with python3Packages; [
    aiorpcx
    colorama
    googleapis-common-protos
    grpcio
    protobuf
    six
    termcolor
  ];

  postInstall = ''
    install README.md -Dt $out/share/doc/charge-lnd
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/charge-lnd --help > /dev/null
  '';

  meta = with lib; {
    description = "Simple policy-based fee manager for lightning network daemon";
    homepage = "https://github.com/accumulator/charge-lnd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mmilata mariaa144 ];
  };
}
