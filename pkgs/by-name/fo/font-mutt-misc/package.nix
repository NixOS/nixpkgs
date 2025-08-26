{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-mutt-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-mutt-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-sSNZ9OEsI7z8tEi5GCl+l1+pG+9Sk9iNPCU0PMdouyQ=";
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
    description = "ClearU pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/mutt-misc";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
