{
  lib,
  stdenv,
  cargo,
  cmake,
  dtc,
  fetchFromGitHub,
  fetchpatch2,
  libxml2,
  llvmPackages,
  makeWrapper,
  ninja,
  nukeReferences,
  pandoc,
  python312,
  qemu,
  rustc,
  rustPlatform,
  symlinkJoin,
  texliveSmall,

  # Empty lists select all upstream boards/configurations.
  microkitBoards ? [ ],
  microkitConfigs ? [ ],
}:

let
  llvmTools = with llvmPackages; [
    clang-unwrapped
    lld
    llvm
  ];

  # The bare-metal initialiser needs the Rust sources to build core and alloc.
  sysroot = symlinkJoin {
    name = "microkit-rust-sysroot";
    paths = [ rustc.unwrapped ];
    postBuild = ''
      mkdir -p "$out/lib/rustlib/src/rust"
      ln -s ${rustPlatform.rustLibSrc} "$out/lib/rustlib/src/rust/library"
    '';
  };

  python = python312.withPackages (
    ps: with ps; [
      autopep8
      jinja2
      jsonschema
      lxml
      ply
      pyaml
      pyfdt
      setuptools
    ]
  );

  tex = texliveSmall.withPackages (
    ps: with ps; [
      enumitem
      environ
      fancyvrb
      fontaxes
      isodate
      parskip
      pdfcol
      roboto
      sfmath
      substr
      tcolorbox
      titlesec
    ]
  );

  sdkFlags = [
    "--sel4=seL4"
    "--llvm"
    "--skip-tar"
    "--tool-target-triple=${stdenv.hostPlatform.rust.rustcTarget}"
  ]
  ++ lib.optional (microkitBoards != [ ]) "--boards=${lib.concatStringsSep "," microkitBoards}"
  ++ lib.optional (microkitConfigs != [ ]) "--configs=${lib.concatStringsSep "," microkitConfigs}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "microkit-sdk";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "seL4";
    repo = "microkit";
    tag = finalAttrs.version;
    hash = "sha256-fBA6iyHMeq7usQ1SoqmZh8eHrKFAEYa1Yzr5PlaGWQ8=";
  };

  # seL4 16.0.0, paired with Microkit 2.3.1 in the upstream release manifest:
  # https://github.com/seL4/microkit-manifest/blob/62206754f47f485aa5ad1604808463bb26fd53d9/default.xml
  sel4Src = fetchFromGitHub {
    owner = "seL4";
    repo = "seL4";
    rev = "6e7c3b733d296cfd88d5fbf635c96e447a882374";
    hash = "sha256-j2OSvxU95t+4wXoUiv4WC49b68ibq4nY2ICSo/33RWg=";
  };

  patches = [
    # Support the PLIC device tree node name used by recent QEMU versions.
    (fetchpatch2 {
      name = "sel4-qemu-plic-node-name.patch";
      url = "https://github.com/seL4/seL4/commit/c6ce4d2a0c334cc9365b2cc41ff0126d75c0ea3c.patch?full_index=1";
      stripLen = 1;
      extraPrefix = "seL4/";
      hash = "sha256-9icfdkgj3Aro3wgAqyNPhWDcWUZ4VVTVQ29b5JTu13s=";
    })
    # Fixes `at least one side of the expression must be absolute` error.
    ./sel4-llvm.patch
  ];

  # The PLIC fix was written after upstream changed CMake indentation.
  patchFlags = [
    "-p1"
    "-l"
  ];

  # out: complete SDK, doc: manual.
  outputs = [
    "out"
    "doc"
  ];

  cargoHash = "sha256-tA/jFH0O/lroAjhihp58nNfsWTClJxTnkxJydKl9jDA=";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = finalAttrs.cargoHash;
  };

  nativeBuildInputs = [
    cargo
    cmake
    dtc
    libxml2
    makeWrapper
    ninja
    nukeReferences
    pandoc
    python
    # seL4 extracts device trees for its QEMU platforms during configuration.
    qemu
    (rustc.override { inherit sysroot; })
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    tex
  ]
  ++ llvmTools;

  __structuredAttrs = true;
  strictDeps = true;

  # Preserve DWARF and the ELF symbols used by the image builder.
  dontStrip = true;
  dontPatchELF = true;
  dontUseCmakeConfigure = true;

  disallowedReferences = [
    sysroot
    (lib.getLib llvmPackages.clang-unwrapped)
  ]
  ++ llvmTools;

  # Keep Rust source paths from retaining the host toolchain.
  env."CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
    "--remap-path-prefix=${sysroot}=/rustc";

  prePatch = ''
    cp -r ${finalAttrs.sel4Src} seL4
    chmod -R u+w seL4

    # Include the dependencies needed by -Z build-std for the initialiser.
    cp -rsn ${rustPlatform.rustVendorSrc}/* "$cargoDepsCopy/source-registry-0/"
  '';

  postPatch = ''
    patchShebangs seL4

    substituteInPlace build_sdk.py \
      --replace-fail '-p initialiser' '-p initialiser -Z build-std=core,alloc' \
      --replace-fail 'RUSTC_BOOTSTRAP=1' 'RUSTC_BOOTSTRAP=1 BINDGEN_EXTRA_CLANG_ARGS=-nostdlibinc'

    # Use LLD when CMake links through Clang, including on Darwin.
    echo 'set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=lld")' >> seL4/llvm.cmake

    # Exclude host headers and keep Clang's resource headers out of the closure.
    substituteInPlace loader/Makefile monitor/Makefile libmicrokit/Makefile \
      --replace-fail '-ffreestanding' \
        '-ffreestanding -nostdlibinc -fdebug-prefix-map=${lib.getLib llvmPackages.clang-unwrapped}=/clang'

    substituteInPlace loader/src/uart.c \
      --replace-fail 'void uart_init()' 'void uart_init(void)'

    # UP builds use the CPU tables only in compile-time size assertions.
    substituteInPlace loader/Makefile \
      --replace-fail '-Wnested-externs' '-Wnested-externs -Wno-unneeded-internal-declaration'
  '';

  buildPhase = ''
    runHook preBuild

    python3 build_sdk.py ${lib.escapeShellArgs sdkFlags}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    sdk="release/microkit-sdk-${finalAttrs.version}"
    mkdir -p "$out/bin" "$out/lib"

    mv "$sdk/doc" "$doc"
    mv "$sdk" "$out/lib/microkit"

    makeWrapper "$out/lib/microkit/bin/microkit" "$out/bin/microkit" \
      --set-default MICROKIT_SDK "$out/lib/microkit"

    runHook postInstall
  '';

  postInstall = ''
    # Remove absolute store paths while preserving DWARF and ELF symbols.
    nuke-refs "$out"/lib/microkit/board/*/*/{elf/*.elf,lib/*.a}
  '';

  meta = {
    description = "A simple operating system framework for the seL4 microkernel";
    homepage = "https://docs.sel4.systems/projects/microkit/";
    changelog = "https://docs.sel4.systems/releases/microkit/${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      r4v3n6101
      wucke13
    ];
    license = with lib.licenses; [
      bsd2
      cc-by-sa-40
      gpl2Only
    ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "microkit";
    outputsToInstall = [ "out" ];
  };
})
