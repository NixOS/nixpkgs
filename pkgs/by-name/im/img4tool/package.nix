{
  lib,
  clangStdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libgeneral,
  libplist,
  openssl,
  lzfse,
  git,
}:
clangStdenv.mkDerivation (finalAttrs: {
  pname = "img4tool";
  version = "217";

  src = fetchFromGitHub {
    owner = "tihmstar";
    repo = "img4tool";
    tag = finalAttrs.version;
    hash = "sha256-67Xfq4jEK9juyaSIgVdWygAePZuyb4Yp8mY+6V66+Aw=";
  };

  # Do not depend on git to calculate version, instead
  # pass version via configureFlag
  patches = [ ./configure-version.patch ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libgeneral
    libplist
    lzfse
    openssl
  ];

  configureFlags = [
    "--with-version-commit-count=${finalAttrs.version}"
  ];

  strictDeps = true;

  meta = {
    description = "Socket daemon to multiplex connections from and to iOS devices";
    homepage = "https://github.com/tihmstar/img4tool";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "img4tool";
  };
})
