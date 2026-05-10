{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  alsa-lib,
  gdk-pixbuf,
  glib,
  libnotify,
  libopus,
  openssl,
  versionCheckHook,
  nix-update-script,
  installShellFiles,

  withNotifications ? true,
  withOgg ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mum";
  version = "0.5.1";
  src = fetchFromGitHub {
    owner = "mum-rs";
    repo = "mum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r2isuwXq79dOQQWB+CsofYCLQYu9VKm7kzoxw103YV4=";
  };

  cargoHash = "sha256-ey3nT6vZ5YOZGk08HykK9RxI7li+Sz+sER3HioGSXP0=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    alsa-lib
    gdk-pixbuf
    glib
    libopus
    openssl
  ]
  ++ lib.optional withNotifications libnotify;

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional withNotifications "notifications" ++ lib.optional withOgg "ogg";

  postInstall = ''
    installManPage documentation/*.{1,5}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/mumctl";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Daemon/cli mumble client";
    homepage = "https://github.com/mum-rs/mum";
    changelog = "https://github.com/mum-rs/mum/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ lykos153 ];
    license = lib.licenses.mit;
  };
})
