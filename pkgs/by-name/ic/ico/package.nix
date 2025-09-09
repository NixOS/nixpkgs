{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libX11,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ico";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/ico-${finalAttrs.version}.tar.xz";
    hash = "sha256-OPNp1DHnUygP3nD6SJzJTOIE+fjqvS9J/H0yr6afRAU=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    xorgproto
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
    description = "Simple animation program that may be used for testing various X11 operations and extensions";
    homepage = "https://gitlab.freedesktop.org/xorg/app/ico";
    license = with lib.licenses; [
      x11
      hpnd
      hpndSellVariant
    ];
    mainProgram = "ico";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
