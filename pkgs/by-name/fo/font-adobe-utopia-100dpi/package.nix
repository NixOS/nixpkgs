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
  pname = "font-adobe-utopia-100dpi";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-adobe-utopia-100dpi-${finalAttrs.version}.tar.xz";
    hash = "sha256-+4TsKXqQaXNUjKWbfG2uqtISRL7F0/sefJPfXvQ7Aks=";
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
    description = "Adobe Utopia 100dpi pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/adobe-utopia-100dpi";
    license = lib.licenses.adobeUtopia;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
