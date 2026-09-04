{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  versionCheckHook,
  rustc,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "freenet-core";
  version = "0.2.133";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "freenet";
    repo = "freenet-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rsXzvLCmaBAfbmyfRXL5Oj3/jYu/80vxS9rfvsHZThA=";
  };

  cargoHash = "sha256-3hjNxLAMQbhQaMRQz1yL3VL84jC82KBnwGATyvSpPl4=";

  cargoBuildFlags = [ "--package=freenet" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postPatch = ''
    substituteInPlace crates/core/build.rs \
      --replace-fail 'chrono::Utc::now()' \
        'chrono::TimeZone::timestamp_opt(&chrono::Utc, '$SOURCE_DATE_EPOCH', 0).unwrap()'
  '';

  # So many of the tests require network connectivity that it isn't
  # worth trying to skip specific ones
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Peer-to-peer platform for decentralized applications";
    homepage = "https://freenet.org/";
    donationPage = "https://freenet.org/donate/";
    changelog = "https://github.com/freenet/freenet-core/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.skyesoss ];
    mainProgram = "freenet";
    inherit (rustc.meta) platforms;
  };
})
