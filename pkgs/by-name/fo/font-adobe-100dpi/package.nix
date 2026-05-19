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
  pname = "font-adobe-100dpi";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-adobe-100dpi-${finalAttrs.version}.tar.xz";
    hash = "sha256-tnr/RF4FYyjVP5cy05iE9V3Y0wP8Ja89u6M6i6NanM8=";
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
    description = "Adobe 100dpi pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/adobe-100dpi";
    license = lib.licenses.hpndSellVariant; # plus a trademark that doesn't change the license
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
