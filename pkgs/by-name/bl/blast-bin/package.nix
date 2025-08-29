{
  lib,
  stdenv,
  fetchurl,
  python3,
  perl,
  blast,
  autoPatchelfHook,
  zlib,
  bzip2,
  glib,
  libxml2,
  coreutils,
  sqlite,
}:
let
  pname = "blast-bin";
  version = "2.16.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-x64-linux.tar.gz";
      hash = "sha256-sLEwmMkB0jsyStFwDnRxu3QIp/f1F9dNX6rXEb526PQ=";
    };
    aarch64-linux = fetchurl {
      url = "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-aarch64-linux.tar.gz";
      hash = "sha256-1EeiMu08R9Glq8qRky4OTT5lQPLJcM7iaqUrmUOS4MI=";
    };
    x86_64-darwin = fetchurl {
      url = "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-x64-macosx.tar.gz";
      hash = "sha256-fu4edyD12q8G452ckrEl2Qct5+uB9JnABd7bCLkyMkw=";
    };
    aarch64-darwin = fetchurl {
      url = "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-aarch64-macosx.tar.gz";
      hash = "sha256-6NpPNLBCHaBRscLZ5fjh5Dv3bjjPk2Gh2+L7xEtiJNs=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    python3
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    zlib
    bzip2
    glib
    libxml2
    sqlite
  ];

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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ natsukium ];
  };
}
