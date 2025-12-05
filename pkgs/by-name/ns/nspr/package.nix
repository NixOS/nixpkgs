{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "nspr";
  version = "4.38.2";

  src = fetchurl {
    url = "mirror://mozilla/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    hash = "sha256-5Akvrqt3vcmzLbERPkIVlI7naOJsRmbbO1pgs18skQU=";
  };

  patches = [
    ./0001-Makefile-use-SOURCE_DATE_EPOCH-for-reproducibility.patch
  ];

  outputs = [
    "out"
    "dev"
  ];
  outputBin = "dev";

  preConfigure = ''
    cd nspr
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure --replace '@executable_path/' "$out/lib/"
    substituteInPlace configure.in --replace '@executable_path/' "$out/lib/"
  '';

  HOST_CC = "cc";
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  configureFlags = [
    "--enable-optimize"
    "--disable-debug"
  ]
  ++ lib.optional stdenv.hostPlatform.is64bit "--enable-64bit";

  postInstall = ''
    find $out -name "*.a" -delete
    moveToOutput share "$dev" # just aclocal
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) firefox firefox-esr;
  };

  meta = with lib; {
    homepage = "https://firefox-source-docs.mozilla.org/nspr/index.html";
    description = "Netscape Portable Runtime, a platform-neutral API for system-level and libc-like functions";
    maintainers = with maintainers; [
      ajs124
      hexa
    ];
    platforms = platforms.all;
    license = licenses.mpl20;
  };
}
