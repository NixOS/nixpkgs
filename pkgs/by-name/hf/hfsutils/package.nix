{
  stdenv,
  lib,
  fetchurl,
  fetchDebianPatch,
  testers,
  autoreconfHook,
  bashNonInteractive,
  tcl,
  tk,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hfsutils";
  version = "3.2.6";

  src = fetchurl {
    urls = [
      "https://fossies.org/linux/misc/old/hfsutils-${finalAttrs.version}.tar.gz"
      "https://ftp2.osuosl.org/pub/clfs/conglomeration/hfsutils/hfsutils-${finalAttrs.version}.tar.gz"
      "ftp://ftp.mars.org/hfs/hfsutils-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-vJ0i1tJSuSDsnN8Y4At2VaYYmz809C5Y1bsVKVcomEA=";
  };

  patches = [
    # extern declarations of errno instead of errno.h include breaks linking
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "15";
      patch = "0002-Fix-FTBFS-with-gcc-3.4.patch";
      hash = "sha256-3xOuEFHJeuVBmdqT/fec1jOxdBiXoUFG7ixGztJlxic=";
    })

    # Support files > 2GB
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "15";
      patch = "0003-Add-support-for-files-larger-than-2GB.patch";
      hash = "sha256-vXRjfJE3mJZyt739Ji5PnMnb94X50QhF0gpwCxRYqc4=";
    })

    # Tcl-interfacing code is old, needs deprecated interp->result
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "15";
      patch = "0004-Add-DUSE_INTERP_RESULT-to-DEFINES-in-Makefile.in.patch";
      hash = "sha256-m0zDWZsMXcytaOyHUqo8Dbb5A9G2DyjX8TCGXvXVpmc=";
    })

    # Fix missing string.h include for strcmp
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "16";
      patch = "0005-Fix-missing-inclusion-of-string.h-in-hpwd.c.patch";
      hash = "sha256-PIksZZle+FCiexvecy4IOayNZD/X+Qa8DdE8Ej/p79U=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace-fail 'exec hfssh' 'exec ${placeholder "out"}/bin/hfssh'
  ''
  # Overriding AR breaks cross
  + ''
    substituteInPlace libhfs/Makefile.in \
      --replace-fail 'AR =' '#AR =' \
      --replace-fail '$(AR) ' '$(AR) rc '
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    bashNonInteractive # allow /bin/sh shebang in hfs to get patched during fixupPhase
    tcl
    tk
  ];

  configureFlags = [
    (lib.strings.withFeatureAs true "tcl" tcl)
    (lib.strings.withFeatureAs true "tk" tk)
  ];

  # Tcl code doesn't pass const strings to API
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  enableParallelBuilding = true;

  # Makefile.in expects already-existing target dirs
  preInstall = ''
    mkdir -p $out/{bin,share/man/man1}
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook # current volume is tracked in $HOME/.hcwd
  ];

  installCheckPhase =
    let
      diskLabel = "Test Disk";
    in
    ''
      runHook preInstallCheck

      # Allow pipeline to fail here
      set +o pipefail
      yes | head -c 819200 > disk.hfs
      set -o pipefail

      $out/bin/hformat -l '${diskLabel}' disk.hfs

      mount_output="$($out/bin/hmount disk.hfs)"
      if ! echo "$mount_output" | grep "${diskLabel}"; then
        echo "Label '${diskLabel}' not found" && exit 1
      fi

      runHook postInstallCheck
    '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "hvol --version";
  };

  meta = {
    description = "Tools for reading and writing Macintosh volumes";
    longDescription = ''
      HFS is the “Hierarchical File System”, the native volume format used on modern Macintosh computers.
      hfsutils is the name of a comprehensive software package being developed to permit manipulation of
      HFS volumes from UNIX and other systems.
    '';
    homepage = "https://www.mars.org/home/rob/proj/hfs/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.OPNA2608 ];
    mainProgram = "hfs";
    platforms = lib.platforms.unix;
  };
})
