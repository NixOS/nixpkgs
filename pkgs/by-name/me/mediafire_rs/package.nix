{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mediafire_rs";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "NicKoehler";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-21X19KRIWAIJ6AU0a/UJeytIphbN6tQ8Q0+Kx9QnefQ=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-DenxW5MuK8uVhD08us+Kthun9jr88+Oc/wI3L7GyqT8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bulk MediaFire downloader";
    homepage = "https://github.com/NicKoehler/mediafire_rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magneticflux- ];
    platforms = lib.platforms.all;
    mainProgram = "mdrs";
  };
})
