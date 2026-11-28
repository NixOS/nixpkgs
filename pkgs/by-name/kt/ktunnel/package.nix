{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:
let
  version = "2.5.0";
in
buildGoModule {
  pname = "ktunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "omrikiei";
    repo = "ktunnel";
    rev = "v${version}";
    sha256 = "sha256-PFlst+i7ixNrs2dxKyEfCMEsslqcFl5ngy9EJrs9LqQ=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  vendorHash = "sha256-9RT5NtsuhFGXHYoP9YFrNfQQlbeu1DB7gDkKgTn5z7g=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # # TODO investigate why some tests are failing
  doCheck = false;

  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/ktunnel" --version
    runHook postInstallCheck
  '';

  meta = {
    description = "Cli that exposes your local resources to kubernetes";
    mainProgram = "ktunnel";
    homepage = "https://github.com/omrikiei/ktunnel";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
