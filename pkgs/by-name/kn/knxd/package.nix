{ lib
, stdenv
, buildPackages
, fetchFromGitHub
, autoreconfHook
, pkg-config
, indent
, perl
, argp-standalone
, fmt_9
, libev
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, withUsb ? stdenv.isLinux, libusb1
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "knxd";
  version = "0.14.61";

  src = fetchFromGitHub {
    owner = "knxd";
    repo = "knxd";
    rev = finalAttrs.version;
    hash = "sha256-b8svjGaxW8YqonhXewebDUitezKoMcZxcUFGd2EKZQ4=";
  };

  postPatch = ''
    sed -i '2i echo ${finalAttrs.version}; exit' tools/version.sh
    sed -i '2i exit' tools/get_libfmt
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config indent perl ];

  buildInputs = [ fmt_9 libev ]
    ++ lib.optional withSystemd systemd
    ++ lib.optional withUsb libusb1
    ++ lib.optional stdenv.isDarwin argp-standalone;

  configureFlags = [
    (lib.enableFeature withSystemd "systemd")
    (lib.enableFeature withUsb "usb")
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  installFlags = lib.optionals withSystemd [
    "systemdsystemunitdir=$(out)/lib/systemd/system"
    "systemdsysusersdir=$(out)/lib/sysusers.d"
  ];

  meta = with lib; {
    description = "Advanced router/gateway for KNX";
    homepage = "https://github.com/knxd/knxd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
