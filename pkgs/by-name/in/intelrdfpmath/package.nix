{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "intelrdfpmath";
  version = "2.0U3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "http://www.netlib.org/misc/intel/IntelRDFPMathLib${
      builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }.tar.gz";
    hash = "sha256-E/aSSy7XHfmxN6ffmHBqDcw7Q8KDoOMvi26tykMFE2o=";
  };

  # unpacks to multiple dirs
  sourceRoot = "LIBRARY";

  installPhase = ''
    runHook preInstall

    install -Dm444 -t "$out/lib" *.a
    install -Dm444 -t "$dev/include" src/bid_{conf,functions}.h
    mkdir -p "$out/lib/pkgconfig"
    cat > "$out/lib/pkgconfig/intelmathlib.pc" << EOF
    Name: intelmathlib
    Version: ${builtins.replaceStrings [ "U" ] [ " Update " ] finalAttrs.version}
    Description: Intel Decimal Floating point math library
    Requires:
    Libs: -L$out/lib -lbid
    Cflags: -I$dev/include/
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Software implementation of the IEEE 754-2008 Decimal Floating-Point Arithmetic specification";
    longDescription = ''
      Software implementation of the IEEE 754-2008 Decimal Floating-Point
      Arithmetic specification, aimed at financial applications, especially in
      cases where legal requirements make it necessary to use decimal, and not
      binary floating-point arithmetic (as computation performed with binary
      floating-point operations may introduce small, but unacceptable errors).
    '';
    homepage = "https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      jk
    ];
    platforms = lib.platforms.all;
  };
})
