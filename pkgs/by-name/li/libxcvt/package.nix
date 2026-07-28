{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxcvt";
  version = "0.1.3";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libxcvt-${finalAttrs.version}.tar.xz";
    hash = "sha256-qSmZiodn3n36NtbaR1HNvu807WMHFPL0p2ezUfJELgE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "VESA CVT standard timing modeline generation library & utility";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcvt";
    license = with lib.licenses; [
      mit
      hpndSellVariant
    ];
    mainProgram = "cvt";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
  };
})
