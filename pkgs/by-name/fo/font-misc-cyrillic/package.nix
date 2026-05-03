{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-misc-cyrillic";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-misc-cyrillic-${finalAttrs.version}.tar.xz";
    hash = "sha256-dgIaf1MGQAGRSlf9CO+uV/draPCiTcqKsbJFR07o6ZM=";
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
    description = "Misc Cyrillic pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/misc-cyrillic";
    license = with lib.licenses; [
      publicDomain
      cronyx
      # misc free
      # "May be distributed and modified without restrictions."
      free
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
