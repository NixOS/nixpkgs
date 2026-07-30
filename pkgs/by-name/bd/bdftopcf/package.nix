{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bdftopcf";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://xorg/individual/util/bdftopcf-${finalAttrs.version}.tar.xz";
    hash = "sha256-vGC+WQQzD6qj3dKu14dL7i8p5Dh8JF1nh1UvBn6wUjo=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorgproto ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/util/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Converts X font from Bitmap Distribution Format to Portable Compiled Format";
    homepage = "https://gitlab.freedesktop.org/xorg/util/bdftopcf";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "bdftopcf";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
