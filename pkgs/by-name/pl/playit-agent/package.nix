{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "playit-agent";
  version = "0.15.13";

  src = fetchFromGitHub {
    owner = "playit-cloud";
    repo = "playit-agent";
    rev = "v${version}";
    hash = "sha256-RRN0KAgFVXQGU6LdNWClBFlqO+Nl4SMNXDWfV0lOhAE=";
  };

  cargoHash = "sha256-OholCFCRFjoSZ3bW4sCztbqEW6BX6vaVlDAcK4o7ZWs=";

  # tests connect to a server
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Global proxy that allows anyone to host a server without port forwarding";
    homepage = "https://github.com/playit-cloud/playit-agent";
    changelog = "https://github.com/playit-cloud/playit-agent/releases/tag/${src.rev}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ IldenH ];
    mainProgram = "playit-agent";
    platforms = lib.platforms.linux;
  };
}
