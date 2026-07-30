{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  versionCheckHook,
  nix-update-script,
  bzip2,
  db,
  gpgme,
  libarchive,
  xz,
  zlib,
  gcc14Stdenv,
}:

let
  theStdenv = if stdenv.isDarwin then gcc14Stdenv else stdenv;
in
theStdenv.mkDerivation (finalAttrs: {
  pname = "reprepro";
  version = "5.4.8";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "reprepro";
    tag = "reprepro-${finalAttrs.version}";
    hash = "sha256-qHqRLWRbSwmpKkUQ8JenUo+CY91EY/h4yHHmq4TacMg=";
  };

  buildInputs = [
    bzip2
    db
    gpgme
    libarchive
    xz
    zlib
  ];

  nativeBuildInputs = [
    autoreconfHook
    versionCheckHook
  ];

  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://salsa.debian.org/debian/reprepro/";
    description = "Debian package repository producer";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ baloo ];
    platforms = lib.platforms.all;
    mainProgram = "reprepro";
  };
})
