{ stdenv, fetchFromGitHub, pkgconfig, autoconf, automake, which, libtool, nasm
, xorg, xrdp }:

stdenv.mkDerivation rec {
  pname = "xorgxrdp";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "neutrinolabs";
    repo = "xorgxrdp";
    rev = "v${version}";
    sha256 = "0fi9bhvykdkwirgcgm5fgkvdzfn983rk077cwyn95pij4xp4g7qb";
  };

  nativeBuildInputs = [ pkgconfig autoconf automake which libtool nasm ];
  buildInputs = [ xorg.xorgserver ];

  postPatch = ''
    # patch from Debian, allows to run xrdp daemon under unprivileged user
    substituteInPlace module/rdpClientCon.c \
      --replace 'g_sck_listen(dev->listen_sck);' 'g_sck_listen(dev->listen_sck); g_chmod_hex(dev->uds_data, 0x0660);'

    substituteInPlace configure.ac \
      --replace 'moduledir=`pkg-config xorg-server --variable=moduledir`' "moduledir=$out/lib/xorg/modules" \
      --replace 'sysconfdir="/etc"' "sysconfdir=$out/etc"
  '';

  preConfigure = "./bootstrap";
  configureFlags = [ "XRDP_CFLAGS=-I${xrdp.src}/common"  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Xorg drivers for xrdp";
    homepage = https://github.com/neutrinolabs/xorgxrdp;
    license = licenses.mit;
    maintainers = with maintainers; [ volth offline ];
    platforms = platforms.linux;
  };
}
