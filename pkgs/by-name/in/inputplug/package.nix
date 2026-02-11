{
  fetchCrate,
  installShellFiles,
  lib,
  libbsd,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "inputplug";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-8Gy0h0QMcittnjuKm+atIJNsY2d6Ua29oab4fkUU+wE=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ libbsd ];

  cargoHash = "sha256-+GbbCAdEkxhyQoe8g4me2jlsuHx4R5vibd2PQLmqNM4=";

  postInstall = ''
    installManPage inputplug.1
  '';

  meta = {
    description = "Monitor XInput events and run arbitrary scripts on hierarchy change events";
    homepage = "https://github.com/andrewshadura/inputplug";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    # `daemon(3)` is deprecated on macOS and `pidfile-rs` needs updating
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ jecaro ];
    mainProgram = "inputplug";
  };
}
