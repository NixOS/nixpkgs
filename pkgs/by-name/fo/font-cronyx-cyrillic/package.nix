{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-cronyx-cyrillic";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-cronyx-cyrillic-${finalAttrs.version}.tar.xz";
    hash = "sha256-3AeBzg3L/9v2quGgAXOhNAP5Kw3pJbylqeEX5OLWt4k=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

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
    description = "Cronyx pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/cronyx-cyrillic";
    license = lib.licenses.cronyx;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
