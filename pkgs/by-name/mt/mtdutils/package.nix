{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  cmocka,
  acl,
  libuuid,
  lzo,
  util-linux,
  zlib,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "mtd-utils";
  version = "2.2.1";

  src = fetchgit {
    url = "git://git.infradead.org/mtd-utils.git";
    rev = "v${version}";
    hash = "sha256-vGgBOKu+ClmyRZHQkAS8r/YJtZihr/oD/yj8V7DeAQ8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ] ++ lib.optional doCheck cmocka;
  buildInputs = [
    acl
    libuuid
    lzo
    util-linux
    zlib
    zstd
  ];

  postPatch = ''
    substituteInPlace ubifs-utils/mount.ubifs \
      --replace-fail "/bin/mount" "${util-linux}/bin/mount"
  '';

  enableParallelBuilding = true;

  configureFlags = [
    (lib.enableFeature doCheck "unit-tests")
    (lib.enableFeature doCheck "tests")
  ];

  makeFlags = [ "AR:=$(AR)" ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  outputs = [
    "out"
    "dev"
  ];

  postInstall = ''
    mkdir -p $dev/lib
    mv *.a $dev/lib/
    mv include $dev/
  '';

  meta = with lib; {
    description = "Tools for MTD filesystems";
    downloadPage = "https://git.infradead.org/mtd-utils.git";
    license = licenses.gpl2Plus;
    homepage = "http://www.linux-mtd.infradead.org/";
    maintainers = with lib.maintainers; [ skeuchel ];
    platforms = with platforms; linux;
  };
}
