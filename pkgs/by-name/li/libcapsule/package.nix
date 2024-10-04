{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  autoconf-archive,
  elfutils,
  getopt,
  gtk-doc,
  intltool,
  libtool,
  makeWrapper,
  patchelf,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libcapsule";
  version = "0.20240806.0";

  src = fetchFromGitLab {
    domain = "gitlab.collabora.com";
    owner = "vivek";
    repo = "libcapsule";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-aJV1u047hCVZhuLvAKe8JvoLe/vGkuuCs/LvD+bLTGU=";
  };
  
  postPatch = ''
    patchShebangs data
  '';

  configureFlags = [ "--enable-host-prefix=no" ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    getopt
    gtk-doc
    intltool
    libtool
    makeWrapper
    patchelf
    pkg-config
  ];

  buildInputs = [
    elfutils
  ];

  postInstall = ''
    # Manually remove /build/source/tests/.libs from the rpath of this specific test binary
    patchelf --shrink-rpath --allowed-rpath-prefixes /nix/store $out/libexec/installed-tests/libcapsule/tests/libcapsule-test-dependent-runpath.so.1

    # Tell programs where to find files
    wrapProgram $out/bin/capsule-init-project \
      --prefix PATH : ${lib.makeBinPath [ getopt pkg-config ]} \
      --set CAPSULE_MKINC $out/share/libcapsule/ \
      --set CAPSULE_SYMBOLS_TOOL $out/bin/capsule-symbols \
      --set CAPSULE_VERSION_TOOL $out/bin/capsule-version
    wrapProgram $out/bin/capsule-mkstublib \
      --prefix PATH : ${lib.makeBinPath [ pkg-config ]} \
      --set CAPSULE_SYMBOLS_TOOL $out/bin/capsule-symbols
  '';

  meta = {
    description = "Segregated dynamic linking library";
    homepage = "https://gitlab.collabora.com/vivek/libcapsule";
    mainProgram = "capsule-init-project";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
