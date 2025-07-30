{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  which,
}:

buildGoModule rec {
  pname = "rego-query";
  version = "0.0.14";

  src = fetchFromSourcehut {
    owner = "~charles";
    repo = "rq";
    rev = "v${version}";
    hash = "sha256-SZnbjPiXW6mw3abyL2475sNq3s5Jw12D9ZqbLfvaHN8=";
  };

  vendorHash = "sha256-fOq62QRx7BoE7RJielTnu1dtvkLy2FkzG59uuMQVLc4=";

  subPackages = [ "cmd/rq" ];

  nativeCheckInputs = [ which ];

  postCheck = ''
    # Place the binary in the usual build location so that the tests will work.
    mkdir -p build
    ln -s $GOPATH/bin/rq build

    sh ./smoketest/smoketest.sh
  '';

  meta = with lib; {
    description = "CLI tool for evaluating Rego Queries";
    mainProgram = "rq";
    homepage = "https://sr.ht/~charles/rq";
    changelog = "https://git.sr.ht/~charles/rq/refs/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ refi64 ];
  };
}
