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

stdenv.mkDerivation (finalAttrs: {
  pname = "rpcbind";
  version = "1.2.9";

  src = fetchgit {
    url = "git://git.linux-nfs.org/projects/steved/rpcbind.git";
    rev = "refs/tags/rpcbind-${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-uiUGSCUkFTFl+hqzXgJEjl4WZCcMi+QxuAGmY0g+fs4=";
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
    maintainers = with lib.maintainers; [ zwang20 ];
    longDescription = ''
      Universal addresses to RPC program number mapper.
    '';
    hasNoMaintainersButDependents = true;
  };
})
