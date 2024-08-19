{
  lib,
  stdenv,
  fetchFromGitHub,
  flex,
  libuuid,
  libx86emu,
  perl,
  kmod,
  systemdMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hwinfo";
  version = "23.2";

  src = fetchFromGitHub {
    owner = "opensuse";
    repo = "hwinfo";
    rev = finalAttrs.version;
    hash = "sha256-YAhsnE1DJ5UlYAuhDxS/5IpfIJB6DrhCT3E0YiKENjU=";
  };

  nativeBuildInputs = [ flex ];

  buildInputs = [
    libuuid
    libx86emu
    perl
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/sbin" "/bin" \
      --replace-fail "/usr/" "/"
    substituteInPlace src/isdn/cdb/Makefile \
      --replace-fail "lex isdn_cdb.lex" "flex isdn_cdb.lex"
    substituteInPlace hwinfo.pc.in \
      --replace-fail "prefix=/usr" "prefix=$out"

    # replace absolute paths with relative, we will prefix PATH later
    substituteInPlace src/hd/hd_int.h \
      --replace-fail "/sbin/modprobe" "${kmod}/bin/modprobe" \
      --replace-fail "/sbin/rmmod" "${kmod}/bin/rmmod" \
      --replace-fail "/usr/bin/udevinfo" "${systemdMinimal}/bin/udevinfo" \
      --replace-fail "/usr/bin/udevadm" "${systemdMinimal}/bin/udevadm"

    # check for leftover references to FHS binaries.
    if grep /sbin /usr/bin src/hd/hd_int.h
    then
      echo "Santity check failed. The above lines should be replaced in src/hd/hd_int.h"
      exit 1
    fi
  '';

  makeFlags = [
    "LIBDIR=/lib"
    "HWINFO_VERSION=${finalAttrs.version}"
  ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Hardware detection tool from openSUSE";
    license = licenses.gpl2Only;
    homepage = "https://github.com/openSUSE/hwinfo";
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.linux;
    mainProgram = "hwinfo";
  };
})
