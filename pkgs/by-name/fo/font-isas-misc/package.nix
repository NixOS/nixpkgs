{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-isas-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-isas-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-R+WVu+baREufb8qiZTmrx7oZieI6+mzcSeIuSEzEOPw=";
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
    description = "Isas Fangsong ti & Song ti pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/isas-misc";
    license = lib.licenses.hpnd;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
