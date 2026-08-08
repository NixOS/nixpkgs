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
  version = "1.7.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "christo-auer";
    repo = "eilmeldung";
    tag = finalAttrs.version;
    hash = "sha256-QCGtuf1XSLpWr72GYUsz20JllWHNJ7Q4cAtNTywi4JM=";
  };

  cargoHash = "sha256-8ICcVeL/wFcrWbdmvu3HVHVsts9541ZkBtxDamLjcok=";

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

  BINDGEN_EXTRA_CLANG_ARGS = lib.concatStringsSep " " [
    "-I${lib.getDev glib}/include/glib-2.0"
    "-I${lib.getLib glib}/lib/glib-2.0/include/"
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
