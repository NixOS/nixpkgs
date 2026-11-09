{
  callPackage,
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeWrapper,
  nix-update-script,
  ocaml-ng,
  python3,
  removeReferencesTo,
  util-linux,
  which,
}:

let
  # The version of ocaml fstar uses.
  ocamlPackages = ocaml-ng.ocamlPackages_5_4;

  fstarZ3 = callPackage ./z3 { };

  karamelSrc = fetchFromGitHub {
    owner = "FStarLang";
    repo = "karamel";
    rev = "98ffca53b25c8ac50f303dae87c083de65cc1db8";
    hash = "sha256-SINvlVvn3b0EsHQ92DEqzAiWL307C9RlglvtgysRt2Q=";
  };
in
ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "fstar";
  version = "2026.10.25";

  # The custom installPhase installs everything into $out.
  outputs = [ "out" ];

  src = fetchFromGitHub {
    owner = "FStarLang";
    repo = "FStar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AT7CVTGaosh7fdVpB0jgBeaHzz8z+MVi23rOYdltu7o=";
  };

  nativeBuildInputs = [
    ocamlPackages.menhir
    which
    util-linux
    installShellFiles
    makeWrapper
    python3
    removeReferencesTo
  ];

  prePatch = ''
    cp -r ${karamelSrc}/. karamel
    chmod -R u+w karamel
    patchShebangs karamel
    patchShebangs .scripts/*.sh
    patchShebangs ulib/ml/app/ints/mk_int_file.sh
  '';

  buildInputs = with ocamlPackages; [
    memtrace
  ];

  propagatedBuildInputs = with ocamlPackages; [
    batteries
    ctypes
    fix
    num
    menhirLib
    pprint
    ppx_deriving
    ppx_deriving_yojson
    ppxlib
    process
    sedlex
    stdint
    uucp
    visitors
    wasm
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
    remove-references-to -t '${ocamlPackages.ocaml}' $out/bin/krml

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

  env.GIT_REV = karamelSrc.rev;

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v([0-9]{4}\\.[0-9]{2}\\.[0-9]{2})$"
      ];
    };
    z3 = fstarZ3;
  };

  meta = {
    description = "ML-like functional programming language aimed at program verification";
    homepage = "https://www.fstar-lang.org";
    changelog = "https://github.com/FStarLang/FStar/raw/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      numinit
    ];
    mainProgram = "fstar.exe";
    platforms = with lib.platforms; darwin ++ linux;
  };
})
