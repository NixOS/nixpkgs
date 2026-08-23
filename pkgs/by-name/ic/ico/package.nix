{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ico";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/ico-${finalAttrs.version}.tar.xz";
    hash = "sha256-VqltZCnDh+VK7CO1IvVISH1duClgkvIbsom2eEUGmRU=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
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
