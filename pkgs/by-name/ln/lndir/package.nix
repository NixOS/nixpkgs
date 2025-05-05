{
  lib,
  stdenv,
  fetchurl,
  updateAutotoolsGnuConfigScriptsHook,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lndir";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/util/lndir-${finalAttrs.version}.tar.xz";
    hash = "sha256-O2VXelV1zOCVZk9UkhZKlpQYAP5ikKEjcx1H8+cQTds=";
  };

  strictDeps = true;

  preConfigure = ''
    export XPROTO_CFLAGS=" "
    export XPROTO_LIBS=" "
    substituteInPlace lndir.c \
      --replace '<X11/Xos.h>' '<string.h>' \
      --replace '<X11/Xfuncproto.h>' '<unistd.h>' \
      --replace '_X_ATTRIBUTE_PRINTF(1,2)' '__attribute__((__format__(__printf__,1,2)))' \
      --replace '_X_ATTRIBUTE_PRINTF(2,3)' '__attribute__((__format__(__printf__,2,3)))' \
      --replace '_X_NORETURN' '__attribute__((noreturn))' \
      --replace 'n_dirs--;' ""
  '';

  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];

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
    description = "Create a shadow directory of symbolic links to another directory tree";
    homepage = "https://gitlab.freedesktop.org/xorg/util/lndir";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "lndir";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
