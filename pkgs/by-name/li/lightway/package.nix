{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "lightway";
  version = "0-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "expressvpn";
    repo = "lightway";
    rev = "8e21da7ab3a97ab75235264e85fa8615f7b0f33b";
    hash = "sha256-1YpXaxPm1BMALhRU25FH5PLJ1IIRfcYA3W6e4c8Si+w=";
  };

  cargoHash = "sha256-4SIE/kGRd2I3sqO+IgItO1PBQHeFv9N4erfVe/9re7A=";

  # Backport fix for Darwin address calculation to vendored wolfSSL 5.8.2.
  # https://github.com/wolfSSL/wolfssl/pull/9537
  # Drop when Lightway bumps wolfSSL past commit 5c2c459, or > 5.8.4.
  postPatch = ''
    patch -Np1 \
      -d $cargoDepsCopy/wolfssl-sys-2.0.0/wolfssl-src \
      -i ${./backport-darwin-address-calc-fix.patch}
  '';

  cargoBuildFlags = lib.cli.toCommandLineGNU { } {
    package = [
      "lightway-client"
      "lightway-server"
    ];

    features = lib.optionals stdenv.hostPlatform.isLinux [
      "io-uring"
    ];
  };

  # Enable ARM crypto extensions, overrides the default stdenv.hostPlatform.gcc.arch.
  env.NIX_CFLAGS_COMPILE =
    with stdenv.hostPlatform;
    lib.optionalString (isAarch && isLinux) "-march=${gcc.arch}+crypto";

  # For wolfSSL.
  nativeBuildInputs = [
    autoconf
    automake
    libtool
    rustPlatform.bindgenHook
  ];

  meta = {
    description = "A modern VPN protocol in Rust";
    homepage = "https://expressvpn.com/lightway";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      dustyhorizon
      usertam
    ];
    platforms = with lib.platforms; darwin ++ linux;
    mainProgram = "lightway-client";
  };
}
