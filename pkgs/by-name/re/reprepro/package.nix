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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reprepro";
  version = "5.4.7";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "reprepro";
    tag = "reprepro-${finalAttrs.version}";
    hash = "sha256-bGfVWOmcXvaE+t9jiZFrnaUTKVPJqGqbPFyThhKK8gQ=";
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
