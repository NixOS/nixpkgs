{
  lib,
  acl,
  autoreconfHook,
  fetchFromGitea,
  libburn,
  libiconv,
  libisofs,
  pkg-config,
  readline,
  stdenv,
  zlib,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libisoburn";
  version = "1.5.8.pl02";

  src = fetchFromGitea {
    domain = "dev.lovelyhq.com";
    owner = "libburnia";
    repo = "libisoburn";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-wYX2foI0YXrhVENz8QqfS9IdXwbsHP7rqYOWzlo8FdM=";
  };

  # Drop the Tcl/Tk frontend and the xorriso-dd-target script, plus their
  # man/info pages. The frontend needs BWidget (not provided by tk), and
  # xorriso-dd-target hardcodes FHS paths for lsblk/dd/umount.
  patches = [
    ./no-tcltk-dd-target.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    readline
    zlib
    libburn
    libisofs
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    acl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "info"
    "man"
  ];

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "http://libburnia-project.org/";
    description = "Enables creation and expansion of ISO-9660 filesystems on CD/DVD/BD";
    changelog = "https://dev.lovelyhq.com/libburnia/libisoburn/src/tag/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    mainProgram = "xorriso";
    inherit (libisofs.meta) platforms;
  };
})
