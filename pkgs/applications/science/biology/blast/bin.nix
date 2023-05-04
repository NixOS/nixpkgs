{ lib
, stdenv
, fetchurl
, python3
, perl
, blast
, autoPatchelfHook
, zlib
, bzip2
, glib
, libxml2
, coreutils
}:
let
  pname = "blast-bin";
  version = "2.13.0";

  srcs = rec {
    x86_64-linux = fetchurl {
      url = "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-x64-linux.tar.gz";
      hash = "sha256-QPK3OdT++GoNI1NHyEpu2/hB2hqHYPQ/vNXFAVCwVEc=";
    };
    aarch64-linux = fetchurl {
      url = "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-x64-arm-linux.tar.gz";
      hash = "sha256-vY8K66k7KunpBUjFsJTTb+ur5n1XmU0/mYxhZsi9ycs=";
    };
    x86_64-darwin = fetchurl {
      url = "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-x64-macosx.tar.gz";
      hash = "sha256-Y0JlOUl9Ego6LTxTCNny3P5c1H3fApPXQm7Z6Zhq9RA=";
    };
    aarch64-darwin = x86_64-darwin;
  };
  src = srcs.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = [ python3 perl ] ++ lib.optionals stdenv.isLinux [ zlib bzip2 glib libxml2 ];

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/* -t $out/bin

    runHook postInstall
  '';

  preFixup = ''
    substituteInPlace $out/bin/get_species_taxids.sh \
      --replace /bin/rm ${coreutils}/bin/rm
  '';

  meta = with lib; {
    inherit (blast.meta) description homepage license;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    maintainers = with maintainers; [ natsukium ];
  };
}
