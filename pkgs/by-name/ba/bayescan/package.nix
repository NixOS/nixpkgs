{
  lib,
  stdenv,
  fetchurl,
  unzip,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "bayescan";
  version = "2.1";

  src = fetchurl {
    url = "https://cmpg.unibe.ch/software/BayeScan/files/BayeScan${version}.zip";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = lib.optional stdenv.cc.isClang llvmPackages.openmp;

  # Disable FORTIFY_SOURCE or the binary fails with "buffer overflow"
  hardeningDisable = [ "fortify" ];

  sourceRoot = "BayeScan${version}/source";

  postPatch = ''
    substituteInPlace Makefile --replace "-static" "" \
                               --replace "g++" "c++"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/doc/bayescan
    cp bayescan_${version} $out/bin
    cp -r ../*pdf ../input_examples ../"R functions" $out/share/doc/bayescan
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];

  meta = with lib; {
    description = "Detecting natural selection from population-based genetic data";
    homepage = "http://cmpg.unibe.ch/software/BayeScan";
    license = licenses.gpl3;
    maintainers = [ maintainers.bzizou ];
    mainProgram = "bayescan_${version}";
    platforms = lib.platforms.all;
  };
}
