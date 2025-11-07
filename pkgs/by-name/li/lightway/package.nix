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
  version = "0-unstable-2025-09-19";

  src = fetchFromGitHub {
    owner = "expressvpn";
    repo = "lightway";
    rev = "dac72eb8af0994de020d71d24114717ecfb9804d";
    hash = "sha256-oHxHJ4D/Xg/zAFiI0bMX3Dc05HXIjk+ZHuGY03cwY+c=";
  };

  cargoHash = "sha256-RFlac10XFJXT3Giayy31kZ3Nn1Q+YsPt/zCdkSV0Atk=";

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
