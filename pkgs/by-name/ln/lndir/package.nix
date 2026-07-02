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

  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];

  preConfigure = ''
    # removes dependency on xorgproto
    # from commit 466f1d85d21f79237123d74598a3d7f073513685
    # also fix build due to missing import of unistd.h
    export XPROTO_CFLAGS=" "
    export XPROTO_LIBS=" "
    substituteInPlace lndir.c \
      --replace-fail '<X11/Xos.h>' "<unistd.h>" \
      --replace-fail '#include <X11/Xfuncproto.h>' "" \
      --replace-fail '_X_ATTRIBUTE_PRINTF(1,2)' '__attribute__((__format__(__printf__,1,2)))' \
      --replace-fail '_X_ATTRIBUTE_PRINTF(2,3)' '__attribute__((__format__(__printf__,2,3)))' \
      --replace-fail '_X_NORETURN' '__attribute__((noreturn))'

    # supposed to make lndir it work on directories with st_nlink set to 1 (such as on btrfs).
    # from commit 26164c05c5a227462e8f076db6018a4c55fa1412
    substituteInPlace lndir.c \
      --replace-fail 'n_dirs--;' ""
  '';

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
