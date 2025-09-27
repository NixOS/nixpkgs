{
  lib,
  stdenv,
  fetchFromGitHub,

  perl,
  pkg-config,

  json_c,
  libaio,
  liburcu,
  linuxHeaders,
  lvm2,
  readline,
  systemd,
  udevCheckHook,
  util-linuxMinimal,

  cmocka,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "multipath-tools";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "opensvc";
    repo = "multipath-tools";
    tag = finalAttrs.version;
    hash = "sha256-Jeiy1bM7vuy2+r/0W1nAhgsncyV6QHdlV55aepAxHAg=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    udevCheckHook
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

  doInstallCheck = true;

  passthru.tests = { inherit (nixosTests) iscsi-multipath-root; };

  meta = {
    description = "Tools for the Linux multipathing storage driver";
    homepage = "http://christophe.varoqui.free.fr/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
