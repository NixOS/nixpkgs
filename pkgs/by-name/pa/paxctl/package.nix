{
  fetchurl,
  lib,
  stdenv,
  elf-header,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paxctl";
  version = "0.9";

  src = fetchurl {
    url = "https://pax.grsecurity.net/paxctl-${finalAttrs.version}.tar.gz";
    sha256 = "0biw882fp1lmgs6kpxznp1v6758r7dg9x8iv5a06k0b82bcdsc53";
  };

  buildInputs = [ elf-header ];

  preBuild = ''
    sed -i Makefile \
      -e 's|--owner 0 --group 0||g' \
      -e '/CC:=gcc/d'
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "MANDIR=share/man/man1"
  ];

  meta = {
    description = "Tool for controlling PaX flags on a per binary basis";
    mainProgram = "paxctl";
    homepage = "https://pax.grsecurity.net";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
})
