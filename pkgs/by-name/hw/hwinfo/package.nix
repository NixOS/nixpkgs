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
  testers,
  binutils,
  writeText,
  runCommand,
  validatePkgConfig,
  gitUpdater,
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

  nativeBuildInputs = [
    flex
    validatePkgConfig
  ];

  buildInputs = [
    libuuid
    libx86emu
    perl
  ];

  postPatch = ''
    # Replace /usr paths with Nix store paths
    substituteInPlace Makefile \
      --replace-fail "/sbin" "/bin" \
      --replace-fail "/usr/" "/"
    substituteInPlace src/isdn/cdb/Makefile \
      --replace-fail "lex isdn_cdb.lex" "flex isdn_cdb.lex"
    substituteInPlace hwinfo.pc.in \
      --replace-fail "prefix=/usr" "prefix=$out"
    substituteInPlace src/isdn/cdb/cdb_hwdb.h \
      --replace-fail "/usr/share" "$out/share"

    # Replace /sbin and /usr/bin paths with Nix store paths
    substituteInPlace src/hd/hd_int.h \
      --replace-fail "/sbin/modprobe" "${kmod}/bin/modprobe" \
      --replace-fail "/sbin/rmmod" "${kmod}/bin/rmmod" \
      --replace-fail "/usr/bin/udevinfo" "${systemdMinimal}/bin/udevinfo" \
      --replace-fail "/usr/bin/udevadm" "${systemdMinimal}/bin/udevadm"
  '';

  makeFlags = [
    "LIBDIR=/lib"
    "HWINFO_VERSION=${finalAttrs.version}"
  ];

  installFlags = [ "DESTDIR=$(out)" ];

  passthru = {
    tests = {
      version = testers.testVersion { package = finalAttrs.finalPackage; };
      pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
      no-usr = testers.testEqualContents {
        assertion = "There should be no /usr/ paths in the binaries";
        # There is a bash script that refers to lshal, which is deprecated and not available in Nixpkgs.
        # We'll allow this line, but nothing else.
        expected = writeText "expected" ''
          if [ -x /usr/bin/lshal ] ; then
        '';
        actual = runCommand "actual" { nativeBuildInputs = [ binutils ]; } ''
          strings ${finalAttrs.finalPackage}/bin/* | grep /usr/ > $out
        '';
      };
    };
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Hardware detection tool from openSUSE";
    license = licenses.gpl2Only;
    homepage = "https://github.com/openSUSE/hwinfo";
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.linux;
    mainProgram = "hwinfo";
    pkgConfigModules = [ "hwinfo" ];
  };
})
