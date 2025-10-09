{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxxf86misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXxf86misc-${finalAttrs.version}.tar.bz2";
    hash = "sha256-qJwD4rDxYjnWeiAxuQA/MbWmhhBrvbPHl/uIrkcq84A=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
  ];

  propagatedBuildInputs = [ xorgproto ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXxf86misc \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Extension library for the XFree86-Misc X extension";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxxf86misc";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "xxf86misc" ];
    platforms = lib.platforms.unix;
  };
})
