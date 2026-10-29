{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libfontenc,
  freetype,
  xorgproto,
  zlib,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mkfontscale";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://xorg/individual/app/mkfontscale-${finalAttrs.version}.tar.xz";
    hash = "sha256-KSHNw0TxrO4EvNbqHilWXBMIJjAG4TSp7jjPnJ1v514=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libfontenc
    freetype
    xorgproto
    zlib
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
    description = "Utilities to create the fonts.scale and fonts.dir index files used by the legacy X11 font system";
    homepage = "https://gitlab.freedesktop.org/xorg/app/mkfontscale";
    license = with lib.licenses; [
      mit
      mitOpenGroup
      hpndSellVariant
    ];
    maintainers = [ ];
    mainProgram = "mkfontscale";
    platforms = lib.platforms.unix;
  };
})
