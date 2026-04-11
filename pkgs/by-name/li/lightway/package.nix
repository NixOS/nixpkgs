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
  version = "0-unstable-2026-04-10";

  src = fetchFromGitHub {
    owner = "expressvpn";
    repo = "lightway";
    rev = "72a924935df9db641e7f4fe28cbeafaead59014f";
    hash = "sha256-tygK2CQmbbynJiwGkMvYzt2dHoE17DCJeqD+jlai/m8=";
  };

  cargoHash = "sha256-NdVOphyBW5sflv5jZPV/ShfAJXb3ZOyDRctmn/2JY38=";

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
