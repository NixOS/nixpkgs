{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxfixes,
  libxrender,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxcursor";
  version = "1.2.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXcursor-${finalAttrs.version}.tar.xz";
    hash = "sha256-/elALdTP552nHi2Wu5gK/F5v9Pin10wVnhlmr7KywsA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxfixes
    libxrender
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXcursor \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X11 Cursor management library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcursor";
    license = lib.licenses.hpndSellVariant;
    maintainers = [ ];
    pkgConfigModules = [ "xcursor" ];
    platforms = lib.platforms.unix;
  };
})
