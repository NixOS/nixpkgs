{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-encodings";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://xorg/individual/font/encodings-${finalAttrs.version}.tar.xz";
    hash = "sha256-n/E8YhdWz6EulfMrpIpbI4Oej1d9AEi+2mbGfatN6XU=";
  };

  strictDeps = true;
  nativeBuildInputs = [ mkfontscale ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname encodings \
        --url https://xorg.freedesktop.org/releases/individual/font/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Font encoding tables for libfontenc";
    homepage = "https://gitlab.freedesktop.org/xorg/font/encodings";
    license = lib.licenses.publicDomain;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
