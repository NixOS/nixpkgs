{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libfontenc,
  freetype,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fonttosfnt";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://xorg/individual/app/fonttosfnt-${finalAttrs.version}.tar.xz";
    hash = "sha256-JJY19n+5T6vUaDcoPEC6jdXnt3TfK6wD1QJqNIB2Y3I=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libfontenc
    freetype
    xorgproto
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/app/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Wraps a set of bdf or pcf bitmap fonts in a sfnt (TrueType or OpenType) wrapper";
    homepage = "https://gitlab.freedesktop.org/xorg/app/fonttosfnt";
    license = lib.licenses.mit;
    mainProgram = "fonttosfnt";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    # something about missing `gzgetc` `gzopen` and `gzclose`
    # works on pkgsMusl so definitely a static problem
    broken = stdenv.hostPlatform.isStatic;
  };
})
