{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  xorgproto,
  libx11,
  libxext,
  libxt,
  ncompress,
  gzip,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxpm";
  version = "3.5.17";

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXpm-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZLMfgQGefTiMgisLKK+NUcRiK4Px8Mtvo/yV4nEibkM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxt
  ];

  propagatedBuildInputs = [
    libx11
  ];

  env = {
    XPM_PATH_COMPRESS = lib.makeBinPath [ ncompress ];
    XPM_PATH_GZIP = lib.makeBinPath [ gzip ];
    XPM_PATH_UNCOMPRESS = lib.makeBinPath [ gzip ];
  };

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname libXpm \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X Pixmap (XPM) image file format library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxpm";
    license = with lib.licenses; [
      x11
      mit
    ];
    mainProgram = "sxpm";
    maintainers = [ ];
    pkgConfigModules = [ "xpm" ];
    platforms = lib.platforms.unix;
  };
})
