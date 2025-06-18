{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  makeBinaryWrapper,
  llvm,
  libclang,
  flex,
  zlib,
  perlPackages,
  util-linux,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "creduce";
  version = "2.10.0-unstable-2024-06-01";

  src = fetchFromGitHub {
    owner = "csmith-project";
    repo = "creduce";
    rev = "31e855e290970cba0286e5032971509c0e7c0a80";
    hash = "sha256-RbxFqZegsCxnUaIIA5OfTzx1wflCPeF+enQt90VwMgA=";
  };

  #LLVM 19 support
  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/csmith-project/creduce/pull/285.patch";
      hash = "sha256-uEkPOeRyrojjH+BCSr/jkOkJazg9zZU/BLn+RTIzHjs=";
    })
  ];

  postUnpack = ''
    substituteInPlace source/CMakeLists.txt --replace-fail "2.11.0" "${finalAttrs.version}"
  '';

  # On Linux, c-reduce's preferred way to reason about
  # the cpu architecture/topology is to use 'lscpu',
  # so let's make sure it knows where to find it:
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace creduce/creduce_utils.pm --replace-fail "lscpu" "${lib.getExe' util-linux "lscpu"}"
  '';

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    llvm.dev
  ];

  buildInputs =
    [
      # Ensure stdenv's CC is on PATH before clang-unwrapped
      stdenv.cc
      # Actual deps:
      llvm
      libclang
      flex
      zlib
    ]
    ++ (with perlPackages; [
      perl
      ExporterLite
      FileWhich
      GetoptTabular
      RegexpCommon
      TermReadKey
    ]);

  postInstall = ''
    wrapProgram $out/bin/creduce --prefix PERL5LIB : "$PERL5LIB"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "C program reducer";
    homepage = "https://embed.cs.utah.edu/creduce";
    # Officially, the license is: https://github.com/csmith-project/creduce/blob/master/COPYING
    license = lib.licenses.ncsa;
    longDescription = ''
      C-Reduce is a tool that takes a large C or C++ program that has a
      property of interest (such as triggering a compiler bug) and
      automatically produces a much smaller C/C++ program that has the same
      property.  It is intended for use by people who discover and report
      bugs in compilers and other tools that process C/C++ code.
    '';
    mainProgram = "creduce";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
