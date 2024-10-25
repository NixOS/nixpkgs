{
  lib,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
}:

python3Packages.buildPythonApplication rec {
  pname = "charge-lnd";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "accumulator";
    repo = "charge-lnd";
    rev = "refs/tags/v${version}";
    hash = "sha256-mNU8bhiZqvYbNUU8vJNk9WbpAVrCTi9Fy3hlIpb06ac=";
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

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    install README.md -Dt $out/share/doc/charge-lnd

    wrapProgram $out/bin/charge-lnd \
      --set PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION "python"
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/charge-lnd --help > /dev/null
  '';

  env = {
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  };

  meta = {
    description = "Simple policy-based fee manager for lightning network daemon";
    homepage = "https://github.com/accumulator/charge-lnd";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      mmilata
      mariaa144
    ];
    mainProgram = "charge-lnd";
  };
}
