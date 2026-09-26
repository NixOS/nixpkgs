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
  version = "1.8.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "christo-auer";
    repo = "eilmeldung";
    tag = finalAttrs.version;
    hash = "sha256-uU79OhQAGDEv+DWhQxOvYHRMBqG7CQ2Sor1cl6q/H30=";
  };

  cargoHash = "sha256-cv09uVsADTdnuTF5ZVPwNtwNIh2nM9QxfOilq1a7b7A=";

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
