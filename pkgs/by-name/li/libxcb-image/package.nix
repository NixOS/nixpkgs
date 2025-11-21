{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  m4,
  xorgproto,
  libxcb,
  libxcb-util,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb-image";
  version = "0.4.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xcb/xcb-util-image-${finalAttrs.version}.tar.xz";
    hash = "sha256-zK2O5drbEnH9RyetFNm9d6ZOUFYIdmxOmCZ9mu3kDT0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    m4
  ];

  buildInputs = [
    xorgproto
    libxcb
    libxcb-util
  ];

  propagatedBuildInputs = [ libxcb ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname xcb-util-image \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "XCB port of Xlib's XImage and XShmImage functions.";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-image";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "xcb-image" ];
    platforms = lib.platforms.unix;
  };
})
