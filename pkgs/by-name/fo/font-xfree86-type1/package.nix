{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-xfree86-type1";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-xfree86-type1-${finalAttrs.version}.tar.xz";
    hash = "sha256-qTwseIpeocACr3yGYs+dmCH7HfUbjSssXgAm39/qSDc=";
  };

  strictDeps = true;

  nativeBuildInputs = [ mkfontscale ];

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
    description = "XFree86 Cusrsor Postscript Type 1 Font";
    homepage = "https://gitlab.freedesktop.org/xorg/font/xfree86-type1";
    license = lib.licenses.x11;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
