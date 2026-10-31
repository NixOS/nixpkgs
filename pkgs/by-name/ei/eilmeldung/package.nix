{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  perl,
  openssl,
  libxml2,
  sqlite,
  glib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "eilmeldung";
  version = "1.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "christo-auer";
    repo = "eilmeldung";
    tag = finalAttrs.version;
    hash = "sha256-xdLNG2dkOOlrZ6Kexw3A5i6ppJmB5cloQ/bIKJaQvGU=";
  };

  cargoHash = "sha256-FolTX7CBaHjJ5MjuoPydXdlPUIvkQldIzcW78CDJIaQ=";

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    libxml2
    sqlite
  ];

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Feature-rich TUI RSS reader based on the news-flash library";
    homepage = "https://github.com/christo-auer/eilmeldung";
    changelog = "https://github.com/christo-auer/eilmeldung/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      christo-auer
      rachitvrma
    ];
    mainProgram = "eilmeldung";
  };
})
