{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  autoreconfHook,
  pkg-config,
  libnl,
  iptables,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jool-cli";
  version = "4.1.14";

  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fAs289FFdUnddkikm4ceA9d/w1qqqaWuPXmAiq3cIA8=";
  };

  patches = [ ./validate-config.patch ];

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libnl
    iptables
  ];

  makeFlags = [
    "-C"
    "src/usr"
  ];

  prePatch = ''
    sed -e 's%^XTABLES_SO_DIR = .*%XTABLES_SO_DIR = '"$out"'/lib/xtables%g' -i src/usr/iptables/Makefile
  '';

  passthru.tests = {
    inherit (nixosTests) jool;
  };

  meta = {
    homepage = "https://www.jool.mx/";
    description = "Fairly compliant SIIT and Stateful NAT64 for Linux - CLI tools";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fpletz ];
  };
})
