{
  lib,
  fetchFromGitHub,
  gzip,
  python3,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (self: {
  pname = "open-english-wordnet";
  version = "2024";

  src = fetchFromGitHub {
    owner = "globalwordnet";
    repo = "english-wordnet";
    rev = "${self.version}-edition";
    hash = "sha256-9HGcVoI4xnkIkGw03oF6jT0a5xqv4pZz1s0l0gvqsyY=";
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
    python scripts/from_yaml.py

    echo Compressing
    gzip --best --no-name --stdout ./wn.xml > 'oewn:${self.version}.xml.gz'

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    python scripts/validate.py
    runHook postCheck
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
