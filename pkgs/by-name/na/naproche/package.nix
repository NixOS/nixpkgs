{
  lib,
  fetchFromGitHub,
  fetchFromCodeberg,
  haskellPackages,
  makeWrapper,
  eprover,
}:

let
  ftlex = haskellPackages.mkDerivation rec {
    pname = "ftlex";
    version = "0.3.9";

    jailbreak = true; # base <= 4.19.1

    src = fetchFromCodeberg {
      owner = "McEarl";
      repo = "ftlex";
      tag = "v${version}";
      hash = "sha256-ApriPcOv/PPlPr8KFgPx+CgxbQnQmifABOxQvnGALFo=";
    };

    # Relax the dependency on megaparsec so we accept ghc967's version (2.7.0)
    patches = [ ./fix-ftlex-megaparsec-dependency.patch ];

    libraryHaskellDepends = (
      with haskellPackages;
      [
        containers
        megaparsec
        mtl
        text
        transformers
      ]
    );

    # tests generate a binary, which we don't have test cases for
    doCheck = false;
  };
in
haskellPackages.mkDerivation rec {
  pname = "Naproche";
  version = "20251110";

  src = fetchFromGitHub {
    owner = "naproche";
    repo = "naproche";
    tag = "naproche-${version}";
    hash = "sha256-oF8vMaGMjve4xFdDKzndFErmOlNpX/d2LnaVT9sEAuA=";
  };

  isExecutable = true;

  buildTools = [
    haskellPackages.hpack
    makeWrapper
  ];

  executableHaskellDepends = (
    with haskellPackages;
    [
      array
      bytestring
      containers
      ghc-prim
      megaparsec
      mtl
      network
      process
      split
      temporary
      text
      threads
      time
      transformers
      uuid
      extra
      ftlex
    ]
  );

  prePatch = "hpack";
  doCheck = false; # Tests are broken in upstream

  postInstall = ''
    wrapProgram $out/bin/Naproche \
      --set-default NAPROCHE_EPROVER ${eprover}/bin/eprover
  '';

  passthru = {
    inherit ftlex;
  };

  homepage = "https://github.com/naproche/naproche#readme";
  description = "Write formal proofs in natural language and LaTeX";
  maintainers = with lib.maintainers; [ jvanbruegge ];
  license = lib.licenses.gpl3Only;
  mainProgram = "Naproche";
}
