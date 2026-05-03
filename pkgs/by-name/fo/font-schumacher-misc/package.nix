{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  font-util,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-schumacher-misc";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-schumacher-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-i4SfDNseVaNMw92LD7N0Q/q7wiTVukQIVWlYEkSmgHA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    bdftopcf
    font-util
    mkfontscale
  ];

  buildInputs = [ font-util ];

  configureFlags = [ "--with-fontrootdir=$(out)/share/fonts/X11" ];

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
    description = "Schumacher pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/schumacher-misc";
    license = lib.licenses.hpnd;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
