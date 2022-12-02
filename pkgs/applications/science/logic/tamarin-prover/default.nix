{ haskellPackages, mkDerivation, fetchFromGitHub, lib
# the following are non-haskell dependencies
, makeWrapper, which, maude, graphviz
}:

let
  version = "1.6.1";
  src = fetchFromGitHub {
    owner  = "tamarin-prover";
    repo   = "tamarin-prover";
    rev    = version;
    sha256 = "sha256:0cz1v7k4d0im749ag632nc34n91b51b0pq4z05rzw1p59a5lza92";
  };

  # tamarin has its own dependencies, but they're kept inside the repo,
  # no submodules. this factors out the common metadata among all derivations
  common = pname: src: {
    inherit pname version src;

    license     = lib.licenses.gpl3;
    homepage    = "https://tamarin-prover.github.io";
    description = "Security protocol verification in the symbolic model";
    maintainers = [ lib.maintainers.thoughtpolice ];
    hydraPlatforms = lib.platforms.linux; # maude is broken on darwin
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
      base64-bytestring blaze-builder
      dlist exceptions fclabels safe SHA syb
    ];
  });

  tamarin-prover-term = mkDerivation (common "tamarin-prover-term" (src + "/lib/term") // {
    postPatch = replaceSymlinks;
    libraryHaskellDepends = (with haskellPackages; [
      attoparsec HUnit
    ]) ++ [ tamarin-prover-utils ];
  });

  tamarin-prover-theory = mkDerivation (common "tamarin-prover-theory" (src + "/lib/theory") // {
    postPatch = replaceSymlinks;
    doHaddock = false; # broken
    libraryHaskellDepends = (with haskellPackages; [
      aeson aeson-pretty parallel uniplate
    ]) ++ [ tamarin-prover-utils tamarin-prover-term ];
  });

  tamarin-prover-sapic = mkDerivation (common "tamarin-prover-sapic" (src + "/lib/sapic") // {
    postPatch = "cp --remove-destination ${src}/LICENSE .";
    doHaddock = false; # broken
    libraryHaskellDepends = (with haskellPackages; [
      raw-strings-qq
    ]) ++ [ tamarin-prover-theory ];
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
  executableToolDepends = [ makeWrapper which maude graphviz ];
  postInstall = ''
    wrapProgram $out/bin/tamarin-prover \
      --prefix PATH : ${lib.makeBinPath [ which maude graphviz ]}
    # so that the package can be used as a vim plugin to install syntax coloration
    install -Dt $out/share/vim-plugins/tamarin-prover/syntax/ etc/syntax/spthy.vim
    install etc/filetype.vim -D $out/share/vim-plugins/tamarin-prover/ftdetect/tamarin.vim
    # Emacs SPTHY major mode
    install -Dt $out/share/emacs/site-lisp etc/spthy-mode.el
  '';

  checkPhase = "./dist/build/tamarin-prover/tamarin-prover test";

  executableHaskellDepends = (with haskellPackages; [
    binary-instances binary-orphans blaze-html conduit file-embed
    gitrev http-types lifted-base monad-control
    resourcet shakespeare threads wai warp yesod-core yesod-static
  ]) ++ [ tamarin-prover-utils
          tamarin-prover-sapic
          tamarin-prover-term
          tamarin-prover-theory
        ];
})
