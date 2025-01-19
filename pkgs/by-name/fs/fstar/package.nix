{
  callPackage,
  fetchFromGitHub,
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

  duneVersion = "3";

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

  meta = with lib; {
    description = "ML-like functional programming language aimed at program verification";
    homepage = "https://www.fstar-lang.org";
    changelog = "https://github.com/FStarLang/FStar/raw/v${version}/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      numinit
    ];
    mainProgram = "fstar.exe";
    platforms = with platforms; darwin ++ linux;
  };
}
