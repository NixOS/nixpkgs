{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fontconfig,
  freetype,
  libx11,
  libxrender,
  xorgproto,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxft";
  version = "2.3.9";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXft-${finalAttrs.version}.tar.xz";
    hash = "sha256-YKJbeJRe1pMmNbO7GJmlF9Md90VuaYZ/+6J/if85dvU=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    freetype
    libx11
    libxrender
    xorgproto
  ];

  propagatedBuildInputs = [
    xorgproto
    # header file dependencies
    freetype
    fontconfig
    libxrender
  ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXft \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X FreeType library";
    longDescription = ''
      libXft is the client side font rendering library, using libfreetype, libX11, and the
      X Render extension to display anti-aliased text.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxft";
    license = lib.licenses.hpndSellVariant;
    maintainers = [ ];
    pkgConfigModules = [ "xft" ];
    platforms = lib.platforms.unix;
  };
})
