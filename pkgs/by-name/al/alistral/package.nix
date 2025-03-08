{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "alistral";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "RustyNova016";
    repo = "Alistral";
    tag = "v${version}";
    hash = "sha256-bt0WCmnk/DAEuQeEvBe5Vdk/AxpfRAafPiEJ7v8HK8Y=";
  };

  # remove if updating to rust 1.85
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail "[package]" ''$'cargo-features = ["edition2024"]\n[package]'\
      --replace-fail 'rust-version = "1.85.0"' 'rust-version = "1.84.1"'
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-BxJmoJbnGfsA+YCvzUvgnkoHl/ClrwHoE3NjlctjCxA=";

  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Wants to create config file where it s not allowed
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://rustynova016.github.io/Alistral/";
    changelog = "https://github.com/RustyNova016/Alistral/blob/${version}/CHANGELOG.md";
    description = " Power tools for Listenbrainz";
    license = licenses.mit;
    maintainers = with maintainers; [ jopejoe1 ];
    mainProgram = "alistral";
  };
}
