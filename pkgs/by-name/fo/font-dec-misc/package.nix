{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-dec-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-dec-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-gtloIB2P+L7A5R3M14G7TU6/F+EQBJRCeb3AIB4WGvc=";
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
    description = "DEC cursors in pcf font format";
    homepage = "https://gitlab.freedesktop.org/xorg/font/dec-misc";
    license = lib.licenses.hpnd;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
