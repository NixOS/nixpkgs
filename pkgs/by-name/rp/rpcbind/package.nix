{
  fetchgit,
  lib,
  stdenv,
  pkg-config,
  libnsl,
  libtirpc,
  autoreconfHook,
  useSystemd ? true,
  systemd,
}:

stdenv.mkDerivation {
  pname = "rpcbind";
  version = "1.2.6";

  src = fetchgit {
    url = "git://git.linux-nfs.org/projects/steved/rpcbind.git";
    rev = "c0c89b3bf2bdf304a5fe3cab626334e0cdaf1ef2";
    hash = "sha256-aidETIZaQYzC3liDGM915wyBWpMrn4OudxEcFS/Iucw=";
  };

  patches = [
    ./sunrpc.patch
  ];

  buildInputs = [
    libnsl
    libtirpc
  ]
  ++ lib.optional useSystemd systemd;

  configureFlags = [
    "--with-systemdsystemunitdir=${
      if useSystemd then "${placeholder "out"}/etc/systemd/system" else "no"
    }"
    "--enable-warmstarts"
    "--with-rpcuser=rpc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "ONC RPC portmapper";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    homepage = "https://linux-nfs.org/";
    maintainers = with lib.maintainers; [ abbradar ];
    longDescription = ''
      Universal addresses to RPC program number mapper.
    '';
  };
}
