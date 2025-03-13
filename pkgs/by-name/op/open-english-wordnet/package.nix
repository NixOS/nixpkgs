{
  lib,
  fetchFromGitHub,
  fetchpatch,
  gzip,
  python3,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (self: {
  pname = "open-english-wordnet";
  version = "2022";

  src = fetchFromGitHub {
    owner = "globalwordnet";
    repo = "english-wordnet";
    rev = "${self.version}-edition";
    hash = "sha256-a1fWIp39uuJZL1aFX/r+ttLB1+kwh/XPHwphgENTQ5M=";
  };

  patches =
    lib.mapAttrsToList
      (
        rev: hash:
        fetchpatch {
          url = "https://github.com/globalwordnet/english-wordnet/commit/${rev}.patch";
          inherit hash;
        }
      )
      {
        # Upstream commit bumping the version number, accidentally omitted from the tagged release
        "bc07902f8995b62c70f01a282b23f40f30630540" = "sha256-1e4MG/k86g3OFUhiShCCbNXnvDKrYFr1KlGVsGl++KI=";
        # PR #982, “merge.py: Make result independent of filesystem order”
        "6da46a48dd76a48ad9ff563e6c807b8271fc83cd" = "sha256-QkkJH7NVGy/IbeSWkotU80IGF4esz0b8mIL9soHdQtQ=";
      };

  # TODO(nicoo): make compression optional?
  nativeBuildInputs = [
    gzip
    (python3.withPackages (p: with p; [ pyyaml ]))
  ];

  # TODO(nicoo): generate LMF and WNDB versions with separate outputs
  buildPhase = ''
    runHook preBuild

    echo Generating wn.xml
    python scripts/from-yaml.py
    python scripts/merge.py

    echo Compressing
    gzip --best --no-name --stdout ./wn.xml > 'oewn:${self.version}.xml.gz'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/share/wordnet 'oewn:${self.version}.xml.gz'
    runHook postInstall
  '';

  meta = with lib; {
    description = "Lexical network of the English language";
    longDescription = ''
      Open English WordNet is a lexical network of the English language grouping
      words into synsets and linking them according to relationships such as
      hypernymy, antonymy and meronymy. It is intended to be used in natural
      language processing applications and provides deep lexical information
      about the English language as a graph.

      Open English WordNet is a fork of the Princeton Wordnet developed under an
      open source methodology.
    '';
    homepage = "https://en-word.net/";
    license = licenses.cc-by-40;
    maintainers = with maintainers; [ nicoo ];
    platforms = platforms.all;
  };
})
