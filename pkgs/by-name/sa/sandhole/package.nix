{
  fetchFromGitHub,
  lib,
  nixosTests,
  rustPlatform,
  cmake,
  perl,
}:
rustPlatform.buildRustPackage rec {
  pname = "sandhole";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "EpicEric";
    repo = "sandhole";
    tag = "v${version}";
    hash = "sha256-30ltOQLobRy/M1v+0jFpBmH5ZkTmkZ+mQP7BX5RKo2s=";
  };

  # All integration tests require networking.
  postPatch = ''
    echo "fn main() {}" > tests/integration/main.rs
  '';

  cargoHash = "sha256-BE7y4VlvINWdJM4/36CDn4YxPWUQnT22YJtcvjup0Ec=";

  buildInputs = [ cmake ];
  nativeBuildInputs = [ perl ];

  useNextest = true;
  checkFlags = [
    # Some unit tests require networking.
    "--skip"
    "login"
  ];

  passthru.tests = nixosTests.sandhole;

  meta = {
    description = "Expose HTTP/SSH/TCP services through SSH port forwarding";
    longDescription = ''
      A reverse proxy that just works with an OpenSSH client.
      No extra software required to beat NAT!
    '';
    homepage = "https://sandhole.com.br";
    changelog = "https://github.com/EpicEric/sandhole/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "sandhole";
    maintainers = with lib.maintainers; [ EpicEric ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
