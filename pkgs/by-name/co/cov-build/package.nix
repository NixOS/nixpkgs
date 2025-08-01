{
  lib,
  stdenv,
  fetchurl,

  autoPatchelfHook,

  alsa-lib,
  libxcrypt-legacy,
  lttng-ust_2_12,
  xorg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "cov-build";
  version = "2022.12.2";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "https://archive.org/download/cov-analysis-linux-${version}.tar/cov-analysis-linux-${version}.tar.gz";
        hash = "sha256-Jr9bMUo9GRp+dgoAPqKxaTqWYWh4djGArdG9ukUK+ZY=";
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://archive.org/download/cov-analysis-linux64-${version}.tar/cov-analysis-linux64-${version}.tar.gz";
        hash = "sha256-CyNKILJXlDMOCXbZZF4r/knz0orRx32oSj+Kpq/nxXQ=";
      }
    else
      throw "Unsupported platform '${stdenv.hostPlatform.system}'";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    alsa-lib
    libxcrypt-legacy
    lttng-ust_2_12
    xorg.libXext
    xorg.libXrender
    xorg.libXtst
    zlib
  ];

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    mv * $out/libexec
    for x in cov-build cov-capture cov-configure cov-emit cov-emit-java \
      cov-export-cva cov-extract-scm cov-help cov-import-scm cov-link \
      cov-internal-clang cov-internal-emit-clang cov-internal-nm \
      cov-internal-emit-java-bytecode cov-internal-reduce cov-translate \
      cov-preprocess cov-internal-pid-to-db cov-manage-emit \
      cov-manage-history; do
        ln -s $out/libexec/bin/$x $out/bin/$x;
    done
  '';

  dontStrip = true;

  meta = {
    description = "Coverity Scan build tools";
    homepage = "https://scan.coverity.com";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
