{
  fetchFromGitHub,
  lib,
  stdenv,

  # nativeBuildInputs
  autoconf,
  automake,
  cmake,
  dune_3,
  git,
  makeWrapper,
  ninja,
  opam,
  pkg-config,
  perl,
  which,

  # buildInputs
  gmp,
  mpfr,
  ocaml-ng,
  sqlite,
  zlib,

  # Erlang
  beamPackages,

  # Java
  jdk,

  # LLVM
  python3,

  # Options
  withErlang ? true,
  withJava ? true,
  withLLVM ? true,
  withRust ? false,
}:
let
  pname = "infer";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-Kq7sJVBqe4ei1HbZz8R+P4V6yxisxEmPVHjyVlpL1aw=";
  };

  # Pre-fetched LLVM source that facebook-clang-plugins would normally download
  llvmSrc = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    tag = "llvmorg-21.1.6";
    hash = "sha256-mqZLJYDEs6FXAjbSOruR2ATZZxemNMagNG9SMjSWBFE=";
  };

  # We need to use 5.3 because stdcompat (a transitive ocaml dependency) is
  # broken on 5.4
  ocamlPackages = ocaml-ng.ocamlPackages_5_3.overrideScope (
    self: super: {
      # Newer ppxlib removed a function needed by 0.36
      ppxlib = super.ppxlib.override { version = "0.34.0"; };
      # Infer bundles charon 0.1.177; nixpkgs unstable has a newer incompatible
      # version
      charon = super.buildDunePackage {
        pname = "charon";
        version = "0.1";
        src = "${src}/dependencies/charon";
        propagatedBuildInputs = with self; [
          easy_logging
          name_matcher_parser
          ppx_deriving
          unionFind
          visitors
          yojson
        ];
      };
    }
  );

  erlangDeps = with beamPackages; [
    erlang
    rebar3
  ];
  javaDeps = [ jdk ];
in
stdenv.mkDerivation {
  inherit pname src version;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    dune_3
    git
    makeWrapper
    ninja
    opam
    pkg-config
    perl
    which
  ]
  ++ (with ocamlPackages; [
    atd
    atdgen
    ocaml
    findlib
    menhir
    ocamlbuild
  ])
  ++ lib.optionals withErlang erlangDeps
  ++ lib.optionals withJava javaDeps
  ++ lib.optional withLLVM python3;

  buildInputs = [
    gmp
    mpfr
    sqlite
    zlib
  ]
  ++ (with ocamlPackages; [
    ansiterminal
    atd
    atdgen
    base64
    bheap
    charon
    cmdliner
    containers
    containers-data
    core
    ctypes
    fmt
    fpath
    iter
    javalib
    memtrace
    menhirLib
    mtime
    ocamlgraph
    ounit
    ounit2
    parmap
    ppx_blob
    ppx_compare
    ppx_enumerate
    ppx_expect
    ppx_fields_conv
    ppx_show
    ppx_yojson_conv
    ppxlib
    pyml
    sawja
    saturn
    sedlex
    spawn
    ocaml_sqlite3
    tdigest
    xmlm
    zarith
  ])
  ++ lib.optionals withErlang erlangDeps
  ++ lib.optionals withJava javaDeps;

  preConfigure = ''
    patchShebangs .

    ${lib.optionalString withLLVM
      # sh
      ''
        # Link in the prefetched llvm source
        mkdir -p facebook-clang-plugins/clang/src/download
        ln -s ${llvmSrc} facebook-clang-plugins/clang/src/download/llvm-project
        # Skip the download step in prepare_clang_src.sh
        substituteInPlace facebook-clang-plugins/clang/src/prepare_clang_src.sh \
          --replace-fail 'curl -L' 'echo "SKIPPED: curl"  #' \
          --replace-fail 'tar xf' 'echo "SKIPPED: tar"  #'

        # Runtimes and bindings fail to build, as it tries to build them using its
        # newly built clang, but infer seems to work with them disabled.
        # Tools are needed because the build requires llvm-config.
        substituteInPlace facebook-clang-plugins/clang/setup.sh \
          --replace-fail '-DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind"' '-DLLVM_ENABLE_RUNTIMES=""'\
          --replace-fail '-DLLVM_BUILD_DOCS=Off' '-DLLVM_BUILD_DOCS=Off -DLLVM_ENABLE_BINDINGS=Off' \
          --replace-fail '-DLLVM_BUILD_TOOLS=Off' '-DLLVM_BUILD_TOOLS=On'
      ''
    }

    # Remove deprecated -j-std atdgen flag, which is removed in current atdgen
    find . -name "dune" -exec sed -i 's/-j-std//g' {} + 2>/dev/null || true

    # Use nix-provided context.
    substituteInPlace infer/dune-workspace.in \
      --replace-fail '(context (opam (switch @OPAMSWITCH@) (name default) (merlin)))' '(context default)'

    ./autogen.sh
  '';

  dontUseCmakeConfigure = true;

  configureFlags = [
    "--prefix=${placeholder "out"}"
  ]
  ++ [
    "--disable-hack-analyzers" # No support on nixpkgs as of writing
    "--disable-python-analyzers" # Needs python 3.10, which is not in nixpkgs
    "--disable-swift-analyzers" # Does not want to build with the current package
  ]
  ++ lib.optional (!withErlang) "--disable-erlang-analyzers"
  ++ lib.optional (!withJava) "--disable-java-analyzers"
  ++ lib.optional (!withLLVM) "--disable-c-analyzers"
  ++ lib.optional withRust "--enable-rust-analyzers";

  buildFlags = [
    # This cuts the build time in half
    "CFLAGS=-O2"
    "CXXFLAGS=-O2"
    # Prevent ocaml warnings 11 and 55 from crashing the build
    "OCAMLPARAM=_,w=-11-55"
  ];

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  postInstall =
    let
      runtimeDeps = lib.optionals withErlang erlangDeps ++ lib.optionals withJava javaDeps;
    in
    lib.optionalString (runtimeDeps != [ ]) ''
      wrapProgram "$out/bin/infer" \
        --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    '';

  meta = {
    description = "Facebook's static analysis tool for Java, C++, Objective-C, and C.";
    homepage = "https://fbinfer.com/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kacper-uminski ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    mainProgram = "infer";
  };
}
