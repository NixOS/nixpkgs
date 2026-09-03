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
  pname = "font-misc-misc";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-misc-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-eavjYfWLshren1ZYmOSGMAzhzGIdUoW+wm4Utqhhj+0=";
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
    description = "Misc pcf fonts in different sizes";
    homepage = "https://gitlab.freedesktop.org/xorg/font/misc-misc";
    license = lib.licenses.publicDomain;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
