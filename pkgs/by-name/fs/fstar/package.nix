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
  ocamlPackages = ocaml-ng.ocamlPackages_5_3;

  fstarZ3 = callPackage ./z3 { };
in
ocamlPackages.buildDunePackage rec {
  pname = "fstar";
  version = "2025.08.07";

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${version}";
    hash = "sha256-IfwMLMbyC1+iPIG48zm6bzhKCHKPOpVaHdlLhU5g3co=";
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
    memtrace
  ];

  propagatedBuildInputs = with ocamlPackages; [
    batteries
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

    # Ensure ocamlfind can locate fstar OCaml libraries
    mkdir -p $OCAMLFIND_DESTDIR
    ln -s -t $OCAMLFIND_DESTDIR/ $out/lib/fstar

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
