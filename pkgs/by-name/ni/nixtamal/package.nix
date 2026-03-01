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
  testers,
  nixtamal,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "nixtamal";
  version = "1.1.2";
  release_year = 2026;

  minimalOCamlVersion = "5.3";

  src = fetchdarcs {
    url = "https://darcs.toastal.in.th/nixtamal/stable/";
    mirrors = [ "https://smeder.ee/~toastal/nixtamal.darcs" ];
    rev = finalAttrs.version;
    hash = "sha256-Sgr3FGMjo/eETc6DA+rnBHKIQ3yUPkFKRRbf4O1Ns/o=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    # For manpages
    python3Packages.docutils
    python3Packages.pygments
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
  ];

  buildInputs = with ocamlPackages; [
    camomile
    cmdliner
    eio
    eio_main
    fmt
    jingoo
    (jsont.override {
      withBrr = false;
      withBytesrw = true;
    })
    kdl
    logs
    ppx_deriving
    ppx_deriving_qcheck
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

  postInstall = ''
    wrapProgram "$out/bin/nixtamal" --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        nix-prefetch-darcs
        nix-prefetch-fossil
        nix-prefetch-git
        nix-prefetch-pijul
      ]
    }
  '';

  passthru.tests.version = testers.testVersion {
    package = nixtamal;
    command = "${nixtamal.meta.mainProgram} --version";
  };

  meta = {
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.unix;
    mainProgram = "nixtamal";
    homepage = "https://nixtamal.toast.al";
    changelog = "https://nixtamal.toast.al/changelog/";
    description = "Fulfilling input pinning for Nix";
    longDescription = ''
      Nixtamal’s keys features

      • Automate the manual work of input pinning, allowing to lock & refresh inputs
      • Declaritive KDL manifest file over imperative CLI flags
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
