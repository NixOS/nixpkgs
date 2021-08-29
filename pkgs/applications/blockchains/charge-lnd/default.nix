{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "charge-lnd";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "accumulator";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cj8ggahnbn55wlkxzf5b9n8rvm30mc95vgcw8b60pzs47q6vncp";
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
    install README.md charge.config.example -Dt $out/share/doc/charge-lnd
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/charge-lnd --help > /dev/null
  '';

  meta = with lib; {
    description = "Simple policy-based fee manager for lightning network daemon";
    homepage = "https://github.com/accumulator/charge-lnd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mmilata ];
  };
}
