{
  lib,
  clangStdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  clang,
  git,
  libgeneral,
  libplist,
  curl,
  openssl,
  lzfse,
}:
clangStdenv.mkDerivation (finalAttrs: {
  pname = "img4tool";
  version = "217";

  src = fetchFromGitHub {
    owner = "tihmstar";
    repo = "img4tool";
    tag = finalAttrs.version;
    hash = "sha256-s0XKg69wSJl4dsyJaahRXoWoxHcQQGZf42v7Ni7OTdA=";
    # Leave DotGit so that autoconfigure can read version from git tags
    leaveDotGit = true;
  };

  postPatch = ''
    # Checking for libgeneral version still fails
    sed -i 's/libgeneral >= 75/libgeneral >= 1/' configure.ac
  '';

  nativeBuildInputs = [
    autoreconfHook
    clang
    git
    pkg-config
  ];

  buildInputs = [
    libgeneral
    libplist
    lzfse
    openssl
  ];

  meta = {
    description = "Socket daemon to multiplex connections from and to iOS devices";
    homepage = "https://github.com/tihmstar/img4tool";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "img4tool";
  };
})
