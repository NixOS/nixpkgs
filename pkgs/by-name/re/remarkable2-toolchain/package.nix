{ lib, stdenv, fetchurl, libarchive, python3, file, which }:

stdenv.mkDerivation rec {
  pname = "remarkable2-toolchain";
  version = "3.1.2";

  src = fetchurl {
    url = "https://storage.googleapis.com/remarkable-codex-toolchain/codex-x86_64-cortexa7hf-neon-rm11x-toolchain-${version}.sh";
    sha256 = "sha256-JKMDRbkvoxwHiTm/o4JdLn3Mm2Ld1LyxTnCCwvnxk4c=";
    executable = true;
  };

  nativeBuildInputs = [
    libarchive
    python3
    file
    which
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    ENVCLEANED=1 $src -y -d $out
  '';

  meta = with lib; {
    description = "Toolchain for cross-compiling to reMarkable 2 tablets";
    homepage = "https://remarkable.engineering/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ tadfisher ];
    platforms = [ "x86_64-linux" ];
  };
}
