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
  version = "1.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "christo-auer";
    repo = "eilmeldung";
    tag = finalAttrs.version;
    hash = "sha256-Hq+MEeyJpsDCAHOavT6RWBUMe0SsS0OC8FoEfkqIM7s=";
  };

  cargoHash = "sha256-fhiH215ZpwK89zm0cCFCzKcZjvs49LJZhRMmhK5ftkc=";

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
