{
  lib,
  acl,
  attr,
  autoreconfHook,
  bzip2,
  fetchFromGitea,
  libburn,
  libcdio,
  libiconv,
  libisofs,
  pkg-config,
  readline,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libisoburn";
  version = "1.5.6";

  src = fetchFromGitea {
    domain = "dev.lovelyhq.com";
    owner = "libburnia";
    repo = "libisoburn";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-16qNVlWFVXfvbte5EgP/u193wK2GV/r22hVX0SZWr+0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    bzip2
    libcdio
    libiconv
    readline
    zlib
    libburn
    libisofs
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    acl
    attr
  ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    acl
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "info"
    "man"
  ];

  strictDeps = true;

  meta = {
    homepage = "http://libburnia-project.org/";
    description = "Enables creation and expansion of ISO-9660 filesystems on CD/DVD/BD";
    changelog = "https://dev.lovelyhq.com/libburnia/libisoburn/src/tag/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    mainProgram = "osirrox";
    maintainers = [ ];
    inherit (libisofs.meta) platforms;
  };
})
