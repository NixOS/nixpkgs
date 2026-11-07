{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  libpcap,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zond";
  version = "0.19.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zond-rs";
    repo = "zond";
    tag = "v${finalAttrs.version}";
    hash = "sha256-diVKZ8Es3TqdR8U7ZtJvEFc/6izWRDwFnq4jo0nMdo8=";
  };

  cargoHash = "sha256-A535727DTdBuNnXYm5xCzGauQ1agUTJkF/z7+bjXcpU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpcap ];

  checkFlagsArray = [
    # Test requires raw socket/packet capture
    "--skip=the_reason_flag_shows_the_packet_behind_a_verdict"
  ];

  __darwinAllowLocalNetworking = true;

  # Some tests fail in strict sandbox on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for Zond Engine";
    homepage = "https://github.com/zond-rs/zond";
    changelog = "https://github.com/zond-rs/zond/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "zond";
  };
})
