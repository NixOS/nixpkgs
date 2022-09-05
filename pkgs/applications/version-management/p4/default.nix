{ stdenv, fetchurl, lib, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "p4";
  version = "2021.2.2201121";

  src = fetchurl {
    # actually  https://cdist2.perforce.com/perforce/r21.2/bin.linux26x86_64/helix-core-server.tgz but upstream deletes releases
    url = "https://web.archive.org/web/20211118024943/https://cdist2.perforce.com/perforce/r21.2/bin.linux26x86_64/helix-core-server.tgz";
    sha256 = "sha256-SrfI2ZD7KDyttCd8+fo8g4UZKljYYO/SbzqrS9tAcC8=";
  };

  sourceRoot = ".";

  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    install -D --target $out/bin p4 p4broker p4d p4p
  '';

  meta = {
    description = "Perforce Command-Line Client";
    homepage = "https://www.perforce.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ corngood ];
  };
}
