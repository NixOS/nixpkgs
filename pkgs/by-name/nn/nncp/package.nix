{
  cfgPath ? "/etc/nncp.hjson",
  curl,
  fetchurl,
  lib,
  genericUpdater,
  go_1_21,
  perl,
  stdenv,
  writeShellScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nncp";
  version = "8.10.0";
  outputs = [
    "out"
    "doc"
    "info"
  ];

  src = fetchurl {
    url = "http://www.nncpgo.org/download/nncp-${finalAttrs.version}.tar.xz";
    sha256 = "154e13ba15c0ea93f54525793b0699e496b2db7281e1555f08d785a528f3f7fc";
  };

  nativeBuildInputs = [
    go_1_21
  ];

  # Build parameters
  CFGPATH = cfgPath;
  SENDMAIL = "sendmail";

  preConfigure = "export GOCACHE=$NIX_BUILD_TOP/gocache";

  buildPhase = ''
    runHook preBuild
    ./bin/build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    PREFIX=$out ./install
    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru.updateScript = genericUpdater {
    versionLister = writeShellScript "nncp-versionLister" ''
      ${curl}/bin/curl -s ${finalAttrs.meta.downloadPage} | ${perl}/bin/perl -lne 'print $1 if /Release.*>([0-9.]+)</'
    '';
  };

  meta = {
    broken = stdenv.isDarwin;
    changelog = "http://www.nncpgo.org/News.html";
    description = "Secure UUCP-like store-and-forward exchanging";
    downloadPage = "http://www.nncpgo.org/Tarballs.html";
    homepage = "http://www.nncpgo.org/";
    license = lib.licenses.gpl3Only;
    longDescription = ''
      This utilities are intended to help build up small size (dozens of
      nodes) ad-hoc friend-to-friend (F2F) statically routed darknet
      delay-tolerant networks for fire-and-forget secure reliable files,
      file requests, Internet mail and commands transmission. All
      packets are integrity checked, end-to-end encrypted, explicitly
      authenticated by known participants public keys. Onion encryption
      is applied to relayed packets. Each node acts both as a client and
      server, can use push and poll behaviour model.

      Out-of-box offline sneakernet/floppynet, dead drops, sequential
      and append-only CD-ROM/tape storages, air-gapped computers
      support. But online TCP daemon with full-duplex resumable data
      transmission exists.
    '';
    maintainers = with lib.maintainers; [
      ehmry
      woffs
    ];
    platforms = lib.platforms.all;
  };
})
