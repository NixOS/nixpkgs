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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "EpicEric";
    repo = "sandhole";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v0wfdVhAOVCkxI59M7x7MneQrEK+Rfua4PcAcBq71Ho=";
  };

  cargoHash = "sha256-WD2f9P42mGN3l111Cr3m75EppAWxsmFFsVSt8dc+RdQ=";

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
