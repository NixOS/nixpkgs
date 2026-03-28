{
  lib,
  stdenv,
  fetchdarcs,
  python3Packages,
  ocamlPackages,
  darwin,
  makeBinaryWrapper,
  coreutils,
  nix-prefetch-darcs,
  nix-prefetch-fossil,
  nix-prefetch-git,
  nix-prefetch-pijul,
  removeReferencesTo,
  testers,
  nixtamal,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "nixtamal";
  version = "1.2.0";
  release_year = 2026;

  minimalOCamlVersion = "5.3";

  src = fetchdarcs {
    url = "https://darcs.toastal.in.th/nixtamal/stable/";
    mirrors = [ "https://smeder.ee/~toastal/nixtamal.darcs" ];
    rev = finalAttrs.version;
    hash = "sha256-e3d+OuKJ6iaS2w9Icnqc0scdaYTPoei53QZz0pwbyyk=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    removeReferencesTo
    # For manpages
    python3Packages.docutils
    python3Packages.pygments
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
  ];

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

    for dep in "${ocamlPackages.ocaml}" "${ocamlPackages.camomile}"
    do
        remove-references-to -t "$dep" "$bin/bin/nixtamal"
    done

    wrapProgram "$bin/bin/nixtamal" --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        nix-prefetch-darcs
        nix-prefetch-fossil
        nix-prefetch-git
        nix-prefetch-pijul
      ]
    }

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
      Nixtamal’s keys features

      • Automate the manual work of input pinning, allowing to lock & refresh inputs
      • Declarative KDL manifest file over imperative CLI flags
      • diff/grep-friendly lockfile
      • Host, forge, VCS-agnostic
      • Choose eval time fetchers (builtins) or build time fetchers (Nixpkgs, default) — which opens up fetching Darcs, Pijul, & Fossil
      • Supports mirrors
      • Override hash algorithm on a per-project & per-input basis — including BLAKE3 support
      • Custom freshness commands
      • No experimental Nix features required
    '';
    maintainers = with lib.maintainers; [ toastal ];
  };
})
