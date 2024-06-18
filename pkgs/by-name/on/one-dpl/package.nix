{
    lib,
    stdenv,
    fetchFromGitHub,
    cmake,
    tbbLatest,
  }:

  stdenv.mkDerivation rec {
    pname = "one-dpl";
    version = "2022.5.0-rc1";

    src = fetchFromGitHub {
      owner = "oneapi-src";
      repo = "oneDPL";
      rev = "oneDPL-${version}";
      hash = "sha256-deaCe2Ih8bG6HeTIbPDCD0qd/Gi7frjRifrB8rwulAw=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ tbbLatest ];

    meta = {
      description = "OneAPI DPC++ Library (oneDPL) https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/dpc-library.html";
      homepage = "https://github.com/oneapi-src/oneDPL";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ SomeoneSerge ];
      mainProgram = "one-dpl";
      platforms = lib.platforms.all;
    };
  }
