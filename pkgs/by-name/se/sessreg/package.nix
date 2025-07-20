{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sessreg";
  version = "1.1.4";

  src = fetchurl {
    url = "mirror://xorg/individual/app/sessreg-${finalAttrs.version}.tar.xz";
    hash = "sha256-ToW1L09lqTRJdTv7AM61138zF+JNB9wjFH8vEWx4U1A=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorgproto ];

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
    description = "Utility to manage utmp & wtmp entries for X sessions";
    homepage = "https://gitlab.freedesktop.org/xorg/app/sessreg";
    license = with lib.licenses; [
      mitOpenGroup
      mit
    ];
    mainProgram = "sessreg";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
