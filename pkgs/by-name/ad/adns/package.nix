{
  lib,
  stdenv,
  fetchurl,
  gnum4,
  autoreconfHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adns";
  version = "1.6.1";

  src = fetchurl {
    urls = [
      "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-${finalAttrs.version}.tar.gz"
      "mirror://gnu/adns/adns-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-cTizeJt1Br1oP0UdT32FMHepGAO3s12G7GZ/D5zUAc0=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./darwin.patch ];

  nativeBuildInputs = [
    gnum4
    autoreconfHook
  ];

  configureFlags = lib.optional stdenv.hostPlatform.isStatic "--disable-dynamic";

  enableParallelBuilding = true;

  # https://www.mail-archive.com/nix-dev@cs.uu.nl/msg01347.html for details.
  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    for prog in $out/bin/*; do
      $prog --help > /dev/null && echo $(basename $prog) shows usage
    done

    runHook postInstallCheck
  '';

  passthru.updateScript = gitUpdater {
    url = "https://www.chiark.greenend.org.uk/ucgi/~ianmdlvl/githttp/adns.git";
    rev-prefix = "adns-";
  };

  meta = {
    homepage = "http://www.chiark.greenend.org.uk/~ian/adns/";
    description = "Asynchronous DNS resolver library";
    license = [
      lib.licenses.gpl3Plus

      # `adns.h` only
      lib.licenses.lgpl2Plus
    ];
    platforms = lib.platforms.unix;
  };
})
