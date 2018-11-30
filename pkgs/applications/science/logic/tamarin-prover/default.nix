{ haskellPackages, mkDerivation, fetchFromGitHub, lib
# the following are non-haskell dependencies
, makeWrapper, which, maude, graphviz, sapic
}:

let
  version = "1.4.0";
  src = fetchFromGitHub {
    owner  = "tamarin-prover";
    repo   = "tamarin-prover";
    rev    = "7ced07a69f8e93178f9a95797479277a736ae572";
    sha256 = "02pyw22h90228g6qybjpdvpcm9d5lh96f5qwmy2hv2bylz05z3nn";
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
    postPatch = replaceSymlinks;
    patches = [ ./ghc-8.4-support-utils.patch ];
    libraryHaskellDepends = with haskellPackages; [
      base base64-bytestring binary blaze-builder bytestring containers
      deepseq dlist fclabels mtl pretty safe SHA syb time transformers
    ];
  });

  tamarin-prover-term = mkDerivation (common "tamarin-prover-term" (src + "/lib/term") // {
    postPatch = replaceSymlinks;
    patches = [ ./ghc-8.4-support-term.patch ];
    libraryHaskellDepends = (with haskellPackages; [
      attoparsec base binary bytestring containers deepseq dlist HUnit
      mtl process safe
    ]) ++ [ tamarin-prover-utils ];
  });

  tamarin-prover-theory = mkDerivation (common "tamarin-prover-theory" (src + "/lib/theory") // {
    postPatch = replaceSymlinks;
    patches = [ ./ghc-8.4-support-theory.patch ];
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

  # Fix problem with MonadBaseControl not being found
  patchPhase = ''
    sed -ie 's,\(import *\)Control\.Monad$,&\
    \1Control.Monad.Trans.Control,' src/Web/Handler.hs

    sed -ie 's~\( *, \)mtl~&\
    \1monad-control~' tamarin-prover.cabal
  '';

  # wrap the prover to be sure it can find maude, sapic, etc
  executableToolDepends = [ makeWrapper which maude graphviz sapic ];
  postInstall = ''
    wrapProgram $out/bin/tamarin-prover \
      --prefix PATH : ${lib.makeBinPath [ which maude graphviz sapic ]}
    # so that the package can be used as a vim plugin to install syntax coloration
    install -Dt $out/share/vim-plugins/tamarin-prover/syntax/ etc/{spthy,sapic}.vim
    install etc/filetype.vim -D $out/share/vim-plugins/tamarin-prover/ftdetect/tamarin.vim
  '';

  checkPhase = "./dist/build/tamarin-prover/tamarin-prover test";

  executableHaskellDepends = (with haskellPackages; [
    base binary binary-orphans blaze-builder blaze-html bytestring
    cmdargs conduit containers monad-control deepseq directory fclabels file-embed
    filepath gitrev http-types HUnit lifted-base mtl monad-unlift parsec process
    resourcet safe shakespeare tamarin-prover-term
    template-haskell text threads time wai warp yesod-core yesod-static
  ]) ++ [ tamarin-prover-utils
          tamarin-prover-term
          tamarin-prover-theory
        ];
})
