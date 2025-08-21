{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  pkg-config,
  which,
  glib,
  gtk3,
  wrapGAppsHook3,
  withGui ? true,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "dvdisaster";
  version = "0.79.10-pl5";

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "dvdisaster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lWvZDB08lZb87l4oEbrdtc6Me4mWHiW3DFNXYoYR3a0=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    which
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
  ]
  ++ lib.optionals withGui [
    gtk3
  ];

  patches = [
    ./md5sum.patch
  ];

  postPatch = ''
    patchShebangs ./
    sed -i 's/dvdisaster48.png/dvdisaster/' contrib/dvdisaster.desktop
  '';

  configureFlags = [
    # Explicit --docdir= is required for on-line help to work:
    "--docdir=share/doc"
    "--with-nls=yes"
    "--with-embedded-src-path=no"
  ]
  ++ lib.optionals (!withGui) [
    "--with-gui=no"
  ]
  ++ lib.optional (stdenv.hostPlatform.isx86_64) "--with-sse2=yes";

  enableParallelBuilding = true;

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    pushd regtest

    mkdir -p "$TMP"/{log,regtest}
    substituteInPlace common.bash \
      --replace-fail /dev/shm "$TMP/log" \
      --replace-fail /var/tmp "$TMP"

    ./runtests.sh

    popd
    runHook postCheck
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    rm -f $out/bin/dvdisaster-uninstall.sh
    mkdir -pv $out/share/applications
    cp contrib/dvdisaster.desktop $out/share/applications/

    for size in 16 24 32 48 64; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps/
      cp contrib/dvdisaster"$size".png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/dvdisaster.png
    done
  '';

  # Tests are heavily CPU-bound
  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    homepage = "https://github.com/speed47/dvdisaster";
    changelog = "https://github.com/speed47/dvdisaster/blob/v${finalAttrs.version}/CHANGELOG";
    description = "Data loss/scratch/aging protection for CD/DVD media (unofficial version)";
    longDescription = ''
      Dvdisaster provides a margin of safety against data loss on CD and
      DVD media caused by scratches or aging media. It creates error correction
      data which is used to recover unreadable sectors if the disc becomes
      damaged at a later time.

      This version is built on top of the latest upstream version (2021),
      it is backwards compatible with it, and adds a list of improvements,
      such as BD-R support, CLI-only mode, and more.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.matteopacini ];
    mainProgram = "dvdisaster";
    # Tests are not parallelized, and take a long time to run (1-3 hours, depending on CPU)
    # Max observed time: ~4 hours on a "big-parallel" builder
    timeout = 4 * 60 * 60;
  };
})
