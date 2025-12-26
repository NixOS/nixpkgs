{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  font-util,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-bh-75dpi";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-bh-75dpi-${finalAttrs.version}.tar.xz";
    hash = "sha256-YCbYwHNWPdPLtIeNAHbu2XDeur0hQjs7Yd2QRBuefNo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    bdftopcf
    font-util
    mkfontscale
  ];

  buildInputs = [ font-util ];

  configureFlags = [ "--with-fontrootdir=$(out)/share/fonts/X11" ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/font/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Luxi 75dpi pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/bh-75dpi";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
