{
  lib,
  stdenv,
  fetchzip,

  buildPackages,
}:

stdenv.mkDerivation {
  pname = "gkermit";
  version = "2.01";

  src = fetchzip {
    url = "https://www.kermitproject.org/ftp/kermit/archives/gku201.tar.gz";
    hash = "sha256-wf7zoMgNkXU7jmjixVHn6QTxzAjAH81Mty1btS3/XVo=";
    stripRoot = false;
  };

  buildPhase = ''
    runHook preBuild
    ${lib.getExe buildPackages.stdenv.cc} -DPOSIX -o gwart gwart.c
    ./gwart gproto.w gproto.c
    ${lib.getExe stdenv.cc} -DPOSIX -DNEEDUNISTD -o gkermit \
      gproto.c gkermit.c gunixio.c gcmdline.c
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 gkermit -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Columbia GPL Kermit file transfer implementation";
    homepage = "https://www.kermitproject.org/gkermit.html";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ nwf ];
  };
}
