{
  lib,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clash-rs";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${version}";
    hash = "sha256-c4XF0F2ifTvbXTMGiJc1EaGTlS/X5ilZTpXe01uHs4Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZSwNlknpZ0zKj+sklmO14Ey5DPZ0Wk9xxMiXwIiuRd0=";

  patches = [
    # Fix error[E0658]: use of unstable library feature `prelude_2024`.
    # See https://github.com/rust-lang/rust/issues/121042.
    ./prelude.patch
  ];

  env = {
    PROTOC = "${protobuf}/bin/protoc";
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Custom protocol, rule based network proxy software";
    homepage = "https://github.com/Watfaq/clash-rs";
    mainProgram = "clash";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
