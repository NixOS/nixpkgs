{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  m4,
  libxcb,
  libxcb-image,
  libxcb-render-util,
  xorgproto,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb-cursor";
  version = "0.1.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/xcb-util-cursor-${finalAttrs.version}.tar.xz";
    hash = "sha256-DK+ZsNYJcPgc5Bx7ppTl6q+DMie7LLzbL23JZmpmPFc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    m4
  ];

  buildInputs = [
    libxcb
    libxcb-image
    libxcb-render-util
    xorgproto
  ];

  propagatedBuildInputs = [ libxcb ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname xcb-util-cursor \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "XCB port of libXcursor";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-cursor";
    license = lib.licenses.x11;
    maintainers = with lib.maintainers; [ lovek323 ];
    pkgConfigModules = [ "xcb-cursor" ];
    platforms = lib.platforms.unix;
  };
})
