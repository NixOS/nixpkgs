{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-misc-ethiopic";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-misc-ethiopic-${finalAttrs.version}.tar.xz";
    hash = "sha256-R0mn5uGh7vbJH8yaBOixwO0CfUDBWZ5abJMnDYRpthI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ mkfontscale ];

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
    description = "Ge'ez Frontiers Foundation's Zemen OpenType and TrueType fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/misc-ethiopic";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
