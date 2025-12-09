{
  apple-sdk,
  cmake,
  fetchFromGitHub,
  git,
  lib,
  libffi,
  llvmPackages_18,
  makeWrapper,
  ncurses,
  python3,
  zlib,

  # *NOT* from LLVM 18!
  # The compiler used to compile Cling may affect the runtime include and lib
  # directories it expects to be run with. Cling builds against (a fork of) Clang,
  # so we prefer to use Clang as the compiler as well for consistency.
  # It would be cleanest to use LLVM 9's clang, but it errors. So, we use a later
  # version of Clang to compile, but we check out the Cling fork of Clang 9 to
  # build Cling against.
  clangStdenv,

  # For runtime C++ standard library
  gcc-unwrapped,

  # Build with debug symbols
  debug ? false,

  # Build with libc++ (LLVM) rather than stdlibc++ (GCC).
  # This is experimental and not all features work.
  useLLVMLibcxx ? clangStdenv.hostPlatform.isDarwin,
}:

let
  stdenv = clangStdenv;

  version = "1.2";

  clingSrc = fetchFromGitHub {
    owner = "root-project";
    repo = "cling";
    rev = "v${version}";
    sha256 = "sha256-ay9FXANJmB/+AdnCR4WOKHuPm6P88wLqoOgiKJwJ8JM=";
  };

  unwrapped = stdenv.mkDerivation {
    pname = "cling-unwrapped";
    inherit version;

    src = fetchFromGitHub {
      owner = "root-project";
      repo = "llvm-project";
      rev = "cling-llvm18-20250721-01";
      sha256 = "sha256-JGteapyujU5w81DsfPQfTq76cYHgk5PbAFbdYfYIDo4=";
    };

    preConfigure = ''
      cp -r ${clingSrc} cling-source

      # Patch a bug in version 1.2 by backporting a fix. See
      # https://github.com/root-project/cling/issues/556
      chmod -R u+w cling-source
      pushd cling-source
      patch -p1 < ${./fix-new-parser.patch}
      popd

      cd llvm
    '';

    nativeBuildInputs = [
      python3
      git
      cmake
    ];
    buildInputs = [
      libffi
      ncurses
      zlib
    ];

    strictDeps = true;

    cmakeFlags = [
      "-DLLVM_EXTERNAL_PROJECTS=cling"
      "-DLLVM_EXTERNAL_CLING_SOURCE_DIR=../../cling-source"
      "-DLLVM_ENABLE_PROJECTS=clang"
      "-DLLVM_TARGETS_TO_BUILD=host;NVPTX"
      "-DLLVM_INCLUDE_TESTS=OFF"
      "-DLLVM_ENABLE_RTTI=ON"
    ]
    ++ lib.optionals (!debug) [
      "-DCMAKE_BUILD_TYPE=Release"
    ]
    ++ lib.optionals debug [
      "-DCMAKE_BUILD_TYPE=Debug"
    ]
    ++ lib.optionals useLLVMLibcxx [
      "-DLLVM_ENABLE_LIBCXX=ON"
      "-DLLVM_ENABLE_LIBCXXABI=ON"
    ];

    CPPFLAGS = if useLLVMLibcxx then [ "-stdlib=libc++" ] else [ ];

    postInstall = ''
      mkdir -p $out/share/Jupyter
      cp -r ../../cling-source/tools/Jupyter/kernel $out/share/Jupyter
    '';

    buildTargets = [ "cling" ];

    dontStrip = debug;

    meta = with lib; {
      description = "Interactive C++ Interpreter";
      mainProgram = "cling";
      homepage = "https://root.cern/cling/";
      license = with licenses; [
        lgpl21
        ncsa
      ];
      maintainers = with maintainers; [ thomasjm ];
      platforms = platforms.unix;
    };
  };

  # The flags passed to the wrapped cling should
  # a) prevent it from searching for system include files and libs, and
  # b) provide it with the include files and libs it needs (C and C++ standard library plus
  # its own stuff)

  # These are also exposed as cling.flags because it's handy to be able to pass them to tools
  # that wrap Cling, particularly Jupyter kernels such as xeus-cling and the built-in
  # jupyter-cling-kernel, which use Cling as a library.
  # Thus, if you're packaging a Jupyter kernel, you either need to pass these flags as extra
  # args to xcpp (for xeus-cling) or put them in the environment variable CLING_OPTS
  # (for jupyter-cling-kernel).
  flags = [
    "-nostdinc"
    "-nostdinc++"

    "-resource-dir"
    "${llvmPackages_18.llvm.lib}/lib"

    "-isystem"
    "${lib.getLib unwrapped}/lib/clang/18/include"
  ]
  ++ lib.optionals useLLVMLibcxx [
    "-I"
    "${lib.getDev llvmPackages_18.libcxx}/include/c++/v1"
    "-L"
    "${llvmPackages_18.libcxx}/lib"
    "-l"
    "${llvmPackages_18.libcxx}/lib/libc++${stdenv.hostPlatform.extensions.sharedLibrary}"
  ]
  ++ lib.optionals (!useLLVMLibcxx) [
    "-I"
    "${gcc-unwrapped}/include/c++/${gcc-unwrapped.version}"
    "-I"
    "${gcc-unwrapped}/include/c++/${gcc-unwrapped.version}/${stdenv.hostPlatform.config}"
  ]
  ++ [
    # System libc on Linux
    # On Darwin, this is an empty directory, so we need a separate include with
    # apple-sdk (see below)
    "-isystem"
    "${lib.getDev stdenv.cc.libc}/include"

    # cling includes
    "-isystem"
    "${lib.getDev unwrapped}/include"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # On Darwin, we need the system includes
    "-isystem"
    "${apple-sdk}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include"
  ];

in

stdenv.mkDerivation {
  pname = "cling";
  version = unwrapped.version;

  nativeBuildInputs = [ makeWrapper ];
  inherit unwrapped flags;
  inherit (unwrapped) meta;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    makeWrapper $unwrapped/bin/cling $out/bin/cling \
      --add-flags "$flags"

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    output=$($out/bin/cling <<EOF
    #include <iostream>
    std::cout << "hello world" << std::endl
    EOF
    )

    echo "$output" | grep -q "Type C++ code and press enter to run it"
    echo "$output" | grep -q "hello world"

    runHook postCheck
  '';

  dontInstall = true;
}
