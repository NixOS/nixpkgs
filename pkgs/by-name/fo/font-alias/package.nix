{
  lib,
  stdenv,
  fetchurl,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-alias";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-alias-${finalAttrs.version}.tar.xz";
    hash = "sha256-n4niF7tz4ONjagpJP7+LfJlRVuDFPZoEdtIBtnwta24=";
  };

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
    description = "Common aliases for Xorg fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/alias";
    license = with lib.licenses; [
      cronyx
      mit
    ];
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
