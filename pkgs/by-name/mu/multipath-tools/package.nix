{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  coreutils,

  perl,
  pkg-config,

  json_c,
  libaio,
  liburcu,
  linuxHeaders,
  lvm2,
  readline,
  systemd,
  util-linuxMinimal,

  cmocka,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "multipath-tools";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "opensvc";
    repo = "multipath-tools";
    rev = "refs/tags/${version}";
    sha256 = "sha256-4cby19BjgnmWf7klK1sBgtZnyvo7q3L1uyVPlVoS+uk=";
  };

  patches = [
    # Backport build fix for musl libc 1.2.5
    (fetchpatch {
      url = "https://github.com/openSUSE/multipath-tools/commit/e5004de8296cd596aeeac0a61b901e98cf7a69d2.patch";
      hash = "sha256-3Qt8zfrWi9aOdqMObZQaNAaXDmjhvSYrXK7qycC9L1Q=";
    })
  ];

  postPatch = ''
    substituteInPlace create-config.mk \
      --replace-fail /bin/echo ${coreutils}/bin/echo

    substituteInPlace multipathd/multipathd.service.in \
      --replace-fail /sbin/multipathd "$out/bin/multipathd"
  '';

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [
    json_c
    libaio
    liburcu
    linuxHeaders
    lvm2
    readline
    systemd
    util-linuxMinimal # for libmount
  ];
  strictDeps = true;

  makeFlags = [
    "LIB=lib"
    "prefix=$(out)"
    "systemd_prefix=$(out)"
    "kernel_incdir=${linuxHeaders}/include/"
    "man8dir=$(out)/share/man/man8"
    "man5dir=$(out)/share/man/man5"
    "man3dir=$(out)/share/man/man3"
  ];

  doCheck = true;
  preCheck = ''
    # skip test attempting to access /sys/dev/block
    substituteInPlace tests/Makefile --replace-fail ' devt ' ' '
  '';
  checkInputs = [ cmocka ];

  passthru.tests = { inherit (nixosTests) iscsi-multipath-root; };

  meta = with lib; {
    description = "Tools for the Linux multipathing storage driver";
    homepage = "http://christophe.varoqui.free.fr/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
