{ haskell, haskellPackages, mkDerivation, fetchFromGitHub, lib
# the following are non-haskell dependencies
, makeWrapper, which, maude, graphviz, sapic
}:

let
  version = "1.3.0";
  src = fetchFromGitHub {
    owner  = "tamarin-prover";
    repo   = "tamarin-prover";
    rev    = "8e823691ad3325bce8921617b013735523d74557";
    sha256 = "0rr2syl9xhv17bwky5p39mhn0bypr24h8pld1xidxv87vy7vk7nr";
  };

  # tamarin has its own dependencies, but they're kept inside the repo,
  # no submodules. this factors out the common metadata among all derivations
  common = pname: src: {
    inherit pname version src;

    license     = lib.licenses.gpl3;
    homepage    = https://tamarin-prover.github.io;
    description = "Security protocol verification in the symbolic model";
    maintainers = [ lib.maintainers.thoughtpolice ];
  };

  # tamarin use symlinks to the LICENSE and Setup.hs files, so for these sublibraries
  # we set the patchPhase to fix that. otherwise, cabal cries a lot.
  replaceSymlinks = ''
    cp --remove-destination ${src}/LICENSE .;
    cp --remove-destination ${src}/Setup.hs .;
  '';

  tamarin-prover-utils = mkDerivation (common "tamarin-prover-utils" (src + "/lib/utils") // {
    patchPhase = replaceSymlinks;
    libraryHaskellDepends = with haskellPackages; [
      base base64-bytestring binary blaze-builder bytestring containers
      deepseq dlist fclabels mtl pretty safe SHA syb time transformers
    ];
  });

  tamarin-prover-term = mkDerivation (common "tamarin-prover-term" (src + "/lib/term") // {
    patchPhase = replaceSymlinks;
    libraryHaskellDepends = (with haskellPackages; [
      attoparsec base binary bytestring containers deepseq dlist HUnit
      mtl process safe
    ]) ++ [ tamarin-prover-utils ];
  });

  tamarin-prover-theory = mkDerivation (common "tamarin-prover-theory" (src + "/lib/theory") // {
    patchPhase = replaceSymlinks;
    doHaddock = false; # broken
    libraryHaskellDepends = (with haskellPackages; [
      aeson aeson-pretty base binary bytestring containers deepseq dlist
      fclabels mtl parallel parsec process safe text transformers uniplate
    ]) ++ [ tamarin-prover-utils tamarin-prover-term ];
  });

in
mkDerivation (common "tamarin-prover" src // {
  isLibrary = false;
  isExecutable = true;

  # strip out unneeded deps manually
  doHaddock = false;
  enableSharedExecutables = false;
  postFixup = "rm -rf $out/lib $out/nix-support $out/share/doc";

  # wrap the prover to be sure it can find maude, sapic, etc
  executableToolDepends = [ makeWrapper which maude graphviz sapic ];
  postInstall = ''
    wrapProgram $out/bin/tamarin-prover \
      --prefix PATH : ${lib.makeBinPath [ which maude graphviz sapic ]}
  '';

  checkPhase = "./dist/build/tamarin-prover/tamarin-prover test";

  executableHaskellDepends = (with haskellPackages; [
    base binary binary-orphans blaze-builder blaze-html bytestring
    cmdargs conduit containers deepseq directory fclabels file-embed
    filepath gitrev http-types HUnit lifted-base mtl parsec process
    resourcet safe shakespeare tamarin-prover-term
    template-haskell text threads time wai warp yesod-core yesod-static
  ]) ++ [ tamarin-prover-utils
          tamarin-prover-term
          tamarin-prover-theory
        ];
})
