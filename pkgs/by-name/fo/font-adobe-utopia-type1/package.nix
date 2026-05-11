{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-adobe-utopia-type1";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-adobe-utopia-type1-${finalAttrs.version}.tar.xz";
    hash = "sha256-TLKAvEdpOwfF4A/Q5a1XIaq+vAVIw/BndOXMPLz3Vpc=";
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
    description = "Adobe Utopia PostScript Type 1 fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/adobe-utopia-type1";
    license = lib.licenses.adobeUtopia;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
