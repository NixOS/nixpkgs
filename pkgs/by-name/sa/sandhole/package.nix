{
  cmake,
  fetchFromGitHub,
  lib,
  perl,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sandhole";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "EpicEric";
    repo = "sandhole";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gIKBqHGwIvskxHCKG91HHO1/AwoRb3+NNpgFDNo0Yfc=";
  };

  cargoHash = "sha256-FNtJK3OlkL8dWSdIPd9EI7/RS2sG6BRlnPjDkpBApJM=";

  # All integration tests require networking.
  postPatch = ''
    echo "fn main() {}" > tests/integration/main.rs
  '';

  nativeBuildInputs = [
    cmake
    perl
  ];
  strictDeps = true;

  useNextest = true;
  checkFlags = [
    # Some unit tests require networking.
    "--skip"
    "login"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Expose HTTP/SSH/TCP services through SSH port forwarding";
    longDescription = ''
      A reverse proxy that just works with an OpenSSH client.
      No extra software required to beat NAT!
    '';
    homepage = "https://sandhole.com.br";
    changelog = "https://github.com/EpicEric/sandhole/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "sandhole";
    maintainers = with lib.maintainers; [ EpicEric ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
