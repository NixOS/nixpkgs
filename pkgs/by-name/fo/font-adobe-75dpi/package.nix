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
  pname = "font-adobe-75dpi";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-adobe-75dpi-${finalAttrs.version}.tar.xz";
    hash = "sha256-EoGmLb7e0WnklcrhpbSH4fM28rTZcdkpEcWcEDmZuRE=";
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
    description = "Adobe 75dpi pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/adobe-75dpi";
    license = lib.licenses.hpndSellVariant; # plus a trademark that doesn't change the license
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
