{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  pkg-config,
  installShellFiles,
  libclang,
  llvmPackages,
  libllvm,
  yaml-cpp,
  elfutils,
  libunwind,
  versionCheckHook,
  enableLibcxx ? false,
  debug ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "clang-uml";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "bkryza";
    repo = "clang-uml";
    rev = finalAttrs.version;
    hash = "sha256-mY6kJnwWLgCeKXSquNTxsnr4S3bKwedgiRixzyLWTK8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ]
  ++ (
    if debug then
      [
        elfutils
        libunwind
      ]
    else
      [ ]
  );

  cmakeFlags = [
    "-DCUSTOM_COMPILE_OPTIONS=-Wno-error=sign-compare"
    "-DGIT_VERSION=${finalAttrs.version}"
  ];

  buildInputs = [
    libclang
    libllvm
    yaml-cpp
  ];

  cmakeBuildType = if debug then "Debug" else "Release";

  clang = if enableLibcxx then llvmPackages.libcxxClang else llvmPackages.clang;

  postInstall = ''
    cp $out/bin/clang-uml $out/bin/clang-uml-unwrapped
    rm $out/bin/clang-uml
    export unwrapped_clang_uml="$out/bin/clang-uml-unwrapped"

    # inject clang and unwrapp_clang_uml variables into wrapper
    substituteAll ${./wrapper} $out/bin/clang-uml
    chmod +x $out/bin/clang-uml

    installShellCompletion --cmd clang-uml \
      --bash $src/packaging/autocomplete/clang-uml \
      --zsh $src/packaging/autocomplete/_clang-uml
  '';

  dontFixup = debug;
  dontStrip = debug;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Customizable automatic UML diagram generator for C++ based on Clang";
    longDescription = ''
      clang-uml is an automatic C++ to UML class, sequence, package and include diagram generator, driven by YAML configuration files.
      The main idea behind the project is to easily maintain up-to-date diagrams within a code-base or document legacy code.
      The configuration file or files for clang-uml define the types and contents of each generated diagram.
      The diagrams can be generated in PlantUML, MermaidJS and JSON formats.
    '';
    maintainers = with lib.maintainers; [ eymeric ];
    homepage = "https://clang-uml.github.io/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    mainProgram = "clang-uml";
  };
})
