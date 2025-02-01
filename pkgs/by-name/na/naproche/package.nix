{
  lib,
  fetchFromGitHub,
  haskellPackages,
  makeWrapper,
  eprover,
}:

with haskellPackages;
mkDerivation {
  pname = "Naproche-SAD";
  version = "unstable-2024-05-19";

  src = fetchFromGitHub {
    owner = "naproche";
    repo = "naproche";
    rev = "ccb35e6eeb31c82bdd8857d5f84deda296ed53ec";
    hash = "sha256-pIRKjbSFP1q8ldMZXm0WSP0FJqy/lQslNQcoed/y9W0=";
  };

  isExecutable = true;

  buildTools = [
    hpack
    makeWrapper
  ];
  executableHaskellDepends = [
    base
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
  ];

  prePatch = "hpack";
  doCheck = false; # Tests are broken in upstream

  postInstall = ''
    wrapProgram $out/bin/Naproche-SAD \
      --set-default NAPROCHE_EPROVER ${eprover}/bin/eprover
  '';

  homepage = "https://github.com/naproche/naproche#readme";
  description = "Write formal proofs in natural language and LaTeX";
  maintainers = with lib.maintainers; [ jvanbruegge ];
  license = lib.licenses.gpl3Only;
  mainProgram = "Naproche-SAD";
}
