{
  lib,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-rs";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x89sFBQ6bAIHvaRTCxqKKgFKo7PpquVze0R6VicwrJw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-jfc0Rmt9eEN3ds5Rakj+IcJcUa28CbhiSu4AfqHurf0=";

  patches = [
    ./unbounded-shifts.patch
  ];

  nativeInstallCheckInputs = [
    protobuf
    versionCheckHook
  ];

  env = {
    # requires features: sync_unsafe_cell, unbounded_shifts, let_chains, ip
    RUSTC_BOOTSTRAP = 1;
  };

  buildFeatures = [
    "shadowsocks"
    "tuic"
    "onion"
  ];

  doCheck = false; # test failed

  postInstall = ''
    # Align with upstream
    ln -s "$out/bin/clash-rs" "$out/bin/clash"
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Custom protocol, rule based network proxy software";
    homepage = "https://github.com/Watfaq/clash-rs";
    mainProgram = "clash";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
