{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "stargate-libcds";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "stargateaudio";
    repo = "libcds";
    rev = version;
    sha256 = "sha256-THThEzS8gGdwn3h0EBttaX5ljZH9Ma2Rcg143+GIdU8=";
  };

  # Fix 'error: unrecognized command line option' in platforms other than x86
  PLAT_FLAGS = lib.optionalString stdenv.hostPlatform.isx86_64 "-mfpmath=sse -mssse3";

  patches = [
    # Remove unnecessary tests (valgrind, coverage)
    ./Makefile.patch

    # Fix for building on darwin
    (fetchpatch {
      name = "malloc-to-stdlib.patch";
      url = "https://github.com/stargateaudio/libcds/commit/65dc08f059deda8ba5707ba6116b616d0ad0bd8d.patch";
      sha256 = "sha256-FIGlobUVrDYOtnHjsWyE420PoULPHEK/3T9Fv8hfTl4=";
    })
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall
    install -D libcds.so -t $out/lib/
    runHook postInstall
  '';

  meta = with lib; {
    description = "C data structure library";
    homepage = "https://github.com/stargateaudio/libcds";
    maintainers = with maintainers; [ yuu ];
    license = licenses.lgpl3Only;
  };
}
