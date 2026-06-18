{
  lib,
  stdenv,
  fetchdarcs,
  python3Packages,
  ocamlPackages,
  darwin,
  makeBinaryWrapper,
  removeReferencesTo,
  installShellFiles,
  coreutils,
  curl,
  gawk,
  nix-prefetch-darcs,
  nix-prefetch-fossil,
  nix-prefetch-git,
  nix-prefetch-pijul,
  testers,
  nixtamal,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "nixtamal";
  version = "1.7.1";
  release_year = 2026;

  minimalOCamlVersion = "5.3";

  src = fetchdarcs {
    url = "https://darcs.toastal.in.th/nixtamal/stable/";
    mirrors = [ "https://smeder.ee/~toastal/nixtamal.darcs" ];
    rev = finalAttrs.version;
    hash = "sha256-C6d6Ra9w0NG78QSVFS4Glj3HoNRugXjowjFOoJbzHT0=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    removeReferencesTo
    installShellFiles
    # Completions
    ocamlPackages.cmdliner
    # For manpages
    python3Packages.docutils
    python3Packages.pygments
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin darwin.sigtool;

  buildInputs = with ocamlPackages; [
    cmdliner
    fmt
    ppx_deriving_qcheck
  ];

  propagatedBuildInputs = with ocamlPackages; [
    camomile
    eio
    eio_main
    jingoo
    (jsont.override {
      withBrr = false;
      withBytesrw = true;
    })
    kdl
    logs
    ppx_deriving
    qcheck-core
    saturn
    stdint
    uri
    xdg
  ];

  checkInputs = with ocamlPackages; [
    alcotest
    qcheck
    qcheck-alcotest
  ];

  postPatch = ''
    substituteInPlace bin/main.ml --subst-var version
    substituteInPlace lib/lock_loader.ml --subst-var release_year
  '';

  doCheck = true;

  outputs = [
    "bin"
    "data"
    "doc"
    "lib"
    "man"
    "out"
  ];

  installPhase = ''
    runHook preInstall

    dune install \
       -j "$NIX_BUILD_CORES" \
       --cache="disabled" \
       --prefix="$out" \
       --bindir="$bin/bin" \
       --datadir="$data/share" \
       --docdir="$doc/share/doc" \
       --mandir="$man/share/man" \
       --libdir="$lib/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib" \
       nixtamal

    for dep in "${ocamlPackages.ocaml}" "${ocamlPackages.camomile}"; do
       remove-references-to -t "$dep" "$bin/bin/nixtamal"
    done

    wrapProgram "$bin/bin/nixtamal" --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        curl
        gawk
        nix-prefetch-darcs
        nix-prefetch-fossil
        nix-prefetch-git
        nix-prefetch-pijul
      ]
    }

    ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) /* sh */ ''
      mkdir -p "$TMPDIR"
      cmdliner tool-completion --standalone-completion bash nixtamal >"$TMPDIR/completion.bash"
      cmdliner tool-completion --standalone-completion zsh nixtamal >"$TMPDIR/completion.zsh"
      substituteInPlace "$TMPDIR/completion.zsh" --replace-fail "_nixtamal_cmdliner" "_nixtamal"

      installShellCompletion --bash --cmd nixtamal "$TMPDIR/completion.bash"
      installShellCompletion --fish --cmd nixtamal "script/completion.fish"
      installShellCompletion --zsh --cmd nixtamal "$TMPDIR/completion.zsh"
    ''}

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = nixtamal.bin;
    command = "${nixtamal.meta.mainProgram} --version";
  };

  meta = {
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.unix;
    mainProgram = "nixtamal";
    outputsToInstall = [
      "bin"
      "data"
      "doc"
      "man"
    ];
    homepage = "https://nixtamal.toast.al";
    changelog = "https://nixtamal.toast.al/changelog/";
    description = "Fulfilling input pinning for Nix";
    longDescription = ''
      • Automate the manual work of input pinning for dependency management
      • Allow easy ways to lock & refresh those inputs
      • Declarative manifest file over imperative CLI flags
      • diff/grep-friendly lockfile
      • Declarative patch/diff management for inputs
      • Host-, forge-, VCS-agnostic
      • Choose eval time fetchers (builtins) or build time fetchers (Nixpkgs, default) — which opens up fetching now-supported Darcs, Pijul, & Fossil
      • Supports mirrors, failing over when a server is down
      • Override hash algorithm on a per-project & per-input basis — including BLAKE3 support
      • Custom freshness commands
      • No experimental Nix features required
    '';
    maintainers = with lib.maintainers; [ toastal ];
  };
})
