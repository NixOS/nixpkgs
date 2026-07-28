{
  lib,
  stdenv,
  fetchurl,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gccmakedep";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/util/gccmakedep-${finalAttrs.version}.tar.xz";
    hash = "sha256-UIj5h2n7Y8Mm6bnSy3yfSmMKKAHdHaBpcdCCkXbPJbY=";
  };

  passthru.updateScript = writeScript "update-${finalAttrs.pname}" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts

    version="$(list-directory-versions --pname ${finalAttrs.pname} \
      --url https://xorg.freedesktop.org/releases/individual/util/ \
      | sort -V | tail -n1)"

    update-source-version ${finalAttrs.pname} "$version"
  '';

  meta = {
    description = "Creates dependencies in makefiles using 'gcc -M'";
    homepage = "https://gitlab.freedesktop.org/xorg/util/gccmakedep";
    license = with lib.licenses; [
      # COPYING file suggests looking at the Copyright headers of every file:
      # upstream issue: https://gitlab.freedesktop.org/xorg/util/gccmakedep/-/issues/1

      # 1. build system files Copyright Red Hat
      hpndSellVariant

      # 2. gccmakedep.man was written by Colin Watson for Debian somewhen
      # earlier than November 2003. While I wasn't able to trace the exact
      # source, between 1997 and 2004 the "Debian Social Contract, Version
      # 1.0" was in effect, which requires all components of the Debian
      # Operating System to be free software, which includes this man page.
      # https://www.debian.org/social_contract.1.0
      free

      # 3. gccmakedep.in, originally named gccmdep.cpp was copied from the
      # XFree86 project around 2000. While it states to be "Based on
      # mdepend.cpp and code supplied by Hongjiu Lu", that doesn't matter
      # because it was supposedly completely rewritten by XFree86.
      # XFree86 code without any explicit Copyright Statement is under X11.
      x11

      # 4. some files don't have any license info, but they are all trivial
    ];
    mainProgram = "gccmakedep";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
