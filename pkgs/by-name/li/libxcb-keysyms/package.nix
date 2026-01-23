{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxcb,
  xorgproto,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb-keysyms";
  version = "0.4.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xcb/xcb-util-keysyms-${finalAttrs.version}.tar.xz";
    hash = "sha256-fCYKUpRBKu1CnfHaL4r9O9B7fLo/7HcvuhWmE6bVxjg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxcb
    xorgproto
  ];

  propagatedBuildInputs = [ libxcb ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname xcb-util-keysyms \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Standard X key constants and conversion to/from keycodes";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-keysyms";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "xcb-keysyms" ];
    platforms = lib.platforms.unix;
  };
})
