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
  version = "3.5.6";

  src = fetchFromGitHub {
    owner = "dbmail";
    repo = "dbmail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gmj9DdF3MF9FFjjHV8yQxuBSbEe2LzSqux0oDQmT6i0=";
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
