{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gut";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "julien040";
    repo = "gut";
    rev = version;
    hash = "sha256-3A6CwGIZGnTFkMRxDdDg/WpUQezNmGjjSz4Rj/6t1GI=";
  };

  vendorHash = "sha256-EL+fsh603ydZfc3coI8VXkvAStQ0fwzBsJIOztB/VHc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/julien040/gut/src/telemetry.gutVersion=${version}"
  ];

  # Depends on `/home` existing
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Alternative git CLI";
    homepage = "https://gut-cli.dev";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "gut";
  };
}
