{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,

  pkg-config,
  curlMinimal,
  glib,
  gmime3,
  libevent,
  libmhash,
  libxcrypt,
  libzdb,
  openssl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dbmail";
  version = "3.5.5";

  src = fetchFromGitHub {
    owner = "dbmail";
    repo = "dbmail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uoK+sj/CQ2CcliQ+vtE9Q3BWVbzpQ5MP8xHVIxe6w2o=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    curlMinimal
    glib
    gmime3
    libmhash
    libevent
    libxcrypt
    libzdb
    openssl
  ];

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  configureFlags = [ "--with-zdb=${libzdb}" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Highly available Message Delivery Agent using SQL storage";
    homepage = "https://dbmail.org";
    downloadPage = "https://github.com/dbmail/dbmail";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "dbmail-imapd";
    maintainers = with lib.maintainers; [ maevii ];
  };
})
