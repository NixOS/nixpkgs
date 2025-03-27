{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "fake-gcs-server";
  version = "1.52.2";

  src = fetchFromGitHub {
    owner = "fsouza";
    repo = "fake-gcs-server";
    tag = "v${version}";
    hash = "sha256-sidMCbJAK3bRGJyyFIUn7e5y0z4O72JWCICHf4JL4yo=";
  };

  vendorHash = "sha256-oTJ4DCsDazo58ozsAKI0BG7rxfF8oeiIl6vQpRng+LM=";

  # Unit tests fail to start the emulator server in some environments (e.g. Hydra) for some reason.
  #
  # Disabling to avoid flakiness.
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Google Cloud Storage emulator & testing library";
    homepage = "https://github.com/fsouza/fake-gcs-server";
    license = lib.licenses.bsd2;
    mainProgram = "fake-gcs-server";
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
