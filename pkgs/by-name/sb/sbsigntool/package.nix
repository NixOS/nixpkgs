{
  lib,
  stdenv,
  fetchgit,
  autoconf,
  automake,
  pkg-config,
  help2man,
  openssl,
  libuuid,
  gnu-efi,
  libbfd,
  util-linux,
  buildPackages,
  deterministic-host-uname,
  # help2man runs host executables
  withMan ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sbsigntool";
  version = "0.9.5";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/jejb/sbsigntools.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5DInWgl1gThjjfGOsts1H1s1GbMCkd0gjbmG3gA3Fhg=";
  };

  patches = [ ./autoconf.patch ];

  prePatch = "patchShebangs .";

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    help2man
    util-linux # for getopt used by create-ccan-tree
    deterministic-host-uname # build system incorrectly uses uname to determine host CPU
  ];
  buildInputs = [
    openssl
    libuuid
    libbfd
    gnu-efi
  ];

  preConfigure = ''
    substituteInPlace configure.ac --replace-fail "@@NIX_GNUEFI@@" "${gnu-efi}"

    CC=${lib.getExe buildPackages.stdenv.cc} lib/ccan.git/tools/create-ccan-tree --build-type=automake lib/ccan "talloc read_write_all build_assert array_size endian"
    touch AUTHORS
    touch ChangeLog

    echo "SUBDIRS = lib/ccan src ${lib.optionalString withMan "docs"}" > Makefile.am

    aclocal
    autoheader
    autoconf
    automake --add-missing -Wno-portability
  '';

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  meta = {
    description = "Tools for maintaining UEFI signature databases";
    homepage = "http://jk.ozlabs.org/docs/sbkeysync-maintaing-uefi-key-databases";
    maintainers = with lib.maintainers; [
      hmenke
      raitobezarius
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ]; # Broken on i686
    license = lib.licenses.gpl3;
  };
})
