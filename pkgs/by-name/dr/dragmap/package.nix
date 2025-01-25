{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  gtest,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dragmap";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Illumina";
    repo = "DRAGMAP";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-f1jsOErriS1I/iUS4CzJ3+Dz8SMUve/ccb3KaE+L7U8=";
  };

  nativebuildInputs = [ boost ];
  buildInputs = [
    gtest
    zlib
  ];

  patches = [
    # pclose is called on a NULL value. This is no longer allowed since
    #  https://github.com/bminor/glibc/commit/64b1a44183a3094672ed304532bedb9acc707554
    ./stdio-pclose.patch

    # Add missing include cstdint.  Upstream does not accept PR. Issue opened at
    # https://github.com/Illumina/DRAGMAP/issues/63
    ./cstdint.patch
  ];

  env = {
    GTEST_INCLUDEDIR = "${gtest.dev}/include";
    CPPFLAGS = "-I ${boost.dev}/include";
    LDFLAGS = "-L ${boost.out}/lib";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp build/release/dragen-os $out/bin/

    runHook postInstall
  '';

  # Tests are launched by default from makefile
  doCheck = false;

  meta = with lib; {
    description = "Open Source version of Dragen mapper for genomics";
    mainProgram = "dragen-os";
    longDescription = ''
      DRAGMAP is an open-source software implementation of the DRAGEN mapper,
      which the Illumina team created to procude the same results as their
      proprietary DRAGEN hardware.
    '';
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ apraga ];
  };
})
