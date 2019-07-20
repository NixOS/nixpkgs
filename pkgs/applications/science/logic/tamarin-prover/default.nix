{ haskellPackages, mkDerivation, fetchFromGitHub, lib
# the following are non-haskell dependencies
, makeWrapper, which, maude, graphviz, ocaml
}:

let
  version = "1.4.1";
  src = fetchFromGitHub {
    owner  = "tamarin-prover";
    repo   = "tamarin-prover";
    rev    = "d2e1c57311ce4ed0ef46d0372c4995b8fdc25323";
    sha256 = "1bf2qvb646jg3qxd6jgp9ja3wlr888wchxi9mfr3kg7hfn63vxbq";
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
    libraryHaskellDepends = with haskellPackages; [
      base base64-bytestring binary blaze-builder bytestring containers
      deepseq dlist fclabels mtl pretty safe SHA syb time transformers
    ];
  });

  tamarin-prover-term = mkDerivation (common "tamarin-prover-term" (src + "/lib/term") // {
    postPatch = replaceSymlinks;
    libraryHaskellDepends = (with haskellPackages; [
      attoparsec base binary bytestring containers deepseq dlist HUnit
      mtl process safe
    ]) ++ [ tamarin-prover-utils ];
  });

  tamarin-prover-theory = mkDerivation (common "tamarin-prover-theory" (src + "/lib/theory") // {
    postPatch = replaceSymlinks;
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

    patch -p1 < ${./sapic-native.patch}
  '';

  postBuild = ''
    cd plugins/sapic && make sapic && cd ../..
  '';

  # wrap the prover to be sure it can find maude, sapic, etc
  executableToolDepends = [ makeWrapper which maude graphviz ];
  postInstall = ''
    wrapProgram $out/bin/tamarin-prover \
      --prefix PATH : ${lib.makeBinPath [ which maude graphviz ]}
    # so that the package can be used as a vim plugin to install syntax coloration
    install -Dt $out/share/vim-plugins/tamarin-prover/syntax/ etc/{spthy,sapic}.vim
    install etc/filetype.vim -D $out/share/vim-plugins/tamarin-prover/ftdetect/tamarin.vim
    install -m0755 ./plugins/sapic/sapic $out/bin/sapic
  '';

  checkPhase = "./dist/build/tamarin-prover/tamarin-prover test";

  executableSystemDepends = [ ocaml ];
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
