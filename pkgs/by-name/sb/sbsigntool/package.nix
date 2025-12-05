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
}:

stdenv.mkDerivation rec {
  pname = "sbsigntool";
  version = "0.9.5";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/jejb/sbsigntools.git";
    rev = "v${version}";
    hash = "sha256-5DInWgl1gThjjfGOsts1H1s1GbMCkd0gjbmG3gA3Fhg=";
  };

  patches = [ ./autoconf.patch ];

  prePatch = "patchShebangs .";

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    help2man
  ];
  buildInputs = [
    openssl
    libuuid
    libbfd
    gnu-efi
  ];

  configurePhase = ''
    runHook preConfigure

    substituteInPlace configure.ac --replace "@@NIX_GNUEFI@@" "${gnu-efi}"

    lib/ccan.git/tools/create-ccan-tree --build-type=automake lib/ccan "talloc read_write_all build_assert array_size endian"
    touch AUTHORS
    touch ChangeLog

    echo "SUBDIRS = lib/ccan src docs" >> Makefile.am

    aclocal
    autoheader
    autoconf
    automake --add-missing -Wno-portability

    ./configure --prefix=$out

    runHook postConfigure
  '';

  meta = with lib; {
    description = "Tools for maintaining UEFI signature databases";
    homepage = "http://jk.ozlabs.org/docs/sbkeysync-maintaing-uefi-key-databases";
    maintainers = with maintainers; [
      hmenke
      raitobezarius
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ]; # Broken on i686
    license = licenses.gpl3;
  };
}
