{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxcb,
  xorgproto,
  m4,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb-wm";
  version = "0.4.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xcb/xcb-util-wm-${finalAttrs.version}.tar.xz";
    hash = "sha256-YsNOIdBiZGh/rqftv2NjLJ8E1V5yEUqkpXu5Xk+Iigs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    m4
  ];

  buildInputs = [
    libxcb
    xorgproto
  ];

  propagatedBuildInputs = [ libxcb ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname xcb-util-wm \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "XCB client and window-manager helpers for ICCCM & EWMH.";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-wm";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [
      "xcb-ewmh"
      "xcb-icccm"
    ];
    platforms = lib.platforms.unix;
  };
})
