{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  stdenv,
  curl,
  openssl,
  buildPackages,
  installShellFiles,
}:

let
  canRunCmd = stdenv.hostPlatform.emulatorAvailable buildPackages;
  gix = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/gix";
  ein = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/ein";
in
rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "GitoxideLabs";
    repo = "gitoxide";
    rev = "v${version}";
    hash = "sha256-hrCWt4cCnlH3NKH5Uugf/rvVN+YpbeZgZ/lhnQGZ2I0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-q35MQGN/tvsK7gg0a/ljoVY6wedy7rwKlSakONgBIgk=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [ curl ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  preFixup = lib.optionalString canRunCmd ''
    installShellCompletion --cmd gix \
      --bash <(${gix} completions --shell bash) \
      --fish <(${gix} completions --shell fish) \
      --zsh <(${gix} completions --shell zsh)

    installShellCompletion --cmd ein \
      --bash <(${ein} completions --shell bash) \
      --fish <(${ein} completions --shell fish) \
      --zsh <(${ein} completions --shell zsh)
  '';

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Command-line application for interacting with git repositories";
    homepage = "https://github.com/GitoxideLabs/gitoxide";
    changelog = "https://github.com/GitoxideLabs/gitoxide/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ syberant ];
  };
}
