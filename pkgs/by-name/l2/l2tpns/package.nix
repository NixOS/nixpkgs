{
  lib,
  stdenv,
  fetchgit,
  libcli,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "l2tpns";
  version = "2.4.1";

  src = fetchgit {
    url = "https://code.ffdn.org/l2tpns/l2tpns";
    tag = finalAttrs.version;
    hash = "sha256-nUC/pReZaEMdLIp74cRV9wq48ZObNLawcFS8hpi5E6A=";
  };

  buildInputs = [
    libcli
  ];

  makeFlags = [
    "INSTALL=install"
    "DESTDIR=$(out)"
    "bindir=/bin"
    "libdir=$(out)/lib"
    "etcdir=/etc/l2tpns"
    "needrestartdir=/etc/needrestart"
    "man5dir=/share/man/man5"
    "man8dir=/share/man/man8"
  ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/$out/lib
    mkdir -p $out/etc/l2tpns
    mkdir -p $out/etc/needrestart
    mkdir -p $out/share/man/man5
    mkdir -p $out/share/man/man8
  '';

  postInstall = ''
    mv $out/$out/lib $out/lib
    rm -r $out/nix
    rm -r $out/etc
  '';

  meta = {
    description = "Layer 2 tunneling protocol network server (LNS)";
    homepage = "https://code.ffdn.org/l2tpns/l2tpns";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ netali ];
    mainProgram = "l2tpns";
    platforms = lib.platforms.all;
  };
})
