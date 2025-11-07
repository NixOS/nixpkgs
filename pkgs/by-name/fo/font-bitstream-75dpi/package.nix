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
  pname = "font-bitstream-75dpi";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-bitstream-75dpi-${finalAttrs.version}.tar.xz";
    hash = "sha256-qus02HQkqcKwzw6FkHBMkMtbQsajtqDvnkZ273c7+CY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    bdftopcf
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
    description = "Bitstream Charter and Terminal 75dpi pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/bitstream-75dpi";
    license = with lib.licenses; [
      hpnd
      # TODO: change this license or remove this comment when
      # https://github.com/spdx/license-list-XML/issues/2824
      # gets resolved
      xfig
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
