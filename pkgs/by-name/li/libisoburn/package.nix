{ lib
, stdenv
, fetchFromGitea
, acl
, attr
, autoreconfHook
, libburn
, libisofs
, pkg-config
, zlib
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
    attr
    zlib
    libburn
    libisofs
  ];

  propagatedBuildInputs = [
    acl
  ];

  outputs = [ "out" "lib" "dev" "info" "man" ];

  strictDeps = true;

  meta = {
    homepage = "http://libburnia-project.org/";
    description = "Enables creation and expansion of ISO-9660 filesystems on CD/DVD/BD ";
    changelog = "https://dev.lovelyhq.com/libburnia/libisoburn/src/tag/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    mainProgram = "osirrox";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (libisofs.meta) platforms;
  };
})
