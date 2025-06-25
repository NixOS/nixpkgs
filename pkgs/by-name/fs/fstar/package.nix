{
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  lib,
  makeWrapper,
  nix-update-script,
  ocaml-ng,
  removeReferencesTo,
  util-linux,
  which,
}:

let
  # The version of ocaml fstar uses.
  ocamlPackages = ocaml-ng.ocamlPackages_4_14;

  fstarZ3 = callPackage ./z3 { };
in
ocamlPackages.buildDunePackage rec {
  pname = "fstar";
  version = "2025.03.25";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    hash = "sha256-PhjfThXF6fJlFHtNEURG4igCnM6VegWODypmRvnZPdA=";
  };

  # Compatibility with sedlex ≥ 3.5
  patches = fetchpatch {
    url = "https://github.com/FStarLang/FStar/commit/11aff952b955d2c9582515ee2d64ca6993ce1b73.patch";
    hash = "sha256-HlppygegUAYYPDVSzFJvMHXdDSoug636bFa19v3TGkc=";
    excludes = [ "fstar.opam" ];
  };

  nativeBuildInputs = [
    ocamlPackages.menhir
    which
    util-linux
    installShellFiles
    makeWrapper
    removeReferencesTo
  ];

  prePatch = ''
    patchShebangs .scripts/*.sh
    patchShebangs ulib/ml/app/ints/mk_int_file.sh
  '';

  buildInputs = with ocamlPackages; [
    batteries
    menhir
    menhirLib
    pprint
    ppx_deriving
    ppx_deriving_yojson
    ppxlib
    process
    sedlex
    stdint
    yojson
    zarith
    memtrace
    mtime
  ];

  preConfigure = ''
    mkdir -p cache
    export DUNE_CACHE_ROOT="$(pwd)/cache"
    export PATH="${lib.makeBinPath [ fstarZ3 ]}''${PATH:+:}$PATH"
    export PREFIX="$out"
  '';

  buildPhase = ''
    runHook preBuild
    make -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make install

    remove-references-to -t '${ocamlPackages.ocaml}' $out/bin/fstar.exe

    for binary in $out/bin/*; do
      wrapProgram "$binary" --prefix PATH : "${lib.makeBinPath [ fstarZ3 ]}"
    done

    src="$(pwd)"
    cd $out
    installShellCompletion --bash $src/.completion/bash/fstar.exe.bash
    installShellCompletion --fish $src/.completion/fish/fstar.exe.fish
    installShellCompletion --zsh --name _fstar.exe $src/.completion/zsh/__fstar.exe
    cd $src

    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(\d{4}\.\d{2}\.\d{2})$"
      ];
    };
    z3 = fstarZ3;
  };

  meta = {
    description = "ML-like functional programming language aimed at program verification";
    homepage = "https://www.fstar-lang.org";
    changelog = "https://github.com/FStarLang/FStar/raw/v${version}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      numinit
    ];
    mainProgram = "fstar.exe";
    platforms = with lib.platforms; darwin ++ linux;
  };
}
