{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-screen-cyrillic";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-screen-cyrillic-${finalAttrs.version}.tar.xz";
    hash = "sha256-j3WLuM1YDH5lVIfR0Ntp0xmsrlTZMrKV2W2dm4P95cA=";
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
    description = "Screen Cyrillic pcf font";
    homepage = "https://gitlab.freedesktop.org/xorg/font/screen-cyrillic";
    license = lib.licenses.cronyx;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
