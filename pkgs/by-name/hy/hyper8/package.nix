{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  versionCheckHook,
  stdenv,
  openssl,
  pkg-config,
  glib,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyper8";
  version = "1.0.1";

  src = fetchFromCodeberg {
    owner = "simonrepp";
    repo = "hyper8";
    tag = finalAttrs.version;
    hash = "sha256-pvtQPL/hPgoKDLYWC/IL04db7Q/FUlgiExthu4xBQEw=";
  };

  cargoHash = "sha256-AQAWGmzixDFfL7wqJJXCvNSYojVtYHRP0zqdj0C8JRE=";

  __structuredAttrs = true;

  env = {
    OPENSSL_DIR = lib.getDev openssl;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  };

  depsBuildBuild = [
    pkg-config
    glib
    gtk3
    libsoup_3
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    webkitgtk_4_1 # broken on darwin systems
  ];

  buildInputs = [
    openssl
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://hyper8.org";
    description = "Static site generator for video publishing.";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    mainProgram = "hyper8";
  };
})
