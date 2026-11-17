{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  xxd,
  libllvm,
  libclang,
  sqlite,
  python3,
  makeBinaryWrapper,
  vim,
  which,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clink";
  version = "2024.12.07-unstable-2026-10-18";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Smattr";
    repo = "clink";
    rev = "97ca7d205e4c470bf6676ac2ab464536ab022fd6";
    hash = "sha256-OAbCD1g4xbeaf+EOisz+BVp8kwLEiGl/3egeRKtJBNo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace libclink/CMakeLists.txt libclink/vimcat/libvimcat/CMakeLists.txt \
      --replace-fail 'COMMAND /usr/bin/env true' 'COMMAND true'

    patchShebangs --build libclink/src libclink/vimcat/libvimcat/src
  '';

  nativeBuildInputs = [
    cmake
    xxd
    libllvm
    sqlite
    python3
    makeBinaryWrapper
  ];

  buildInputs = [
    libclang
    sqlite
    # Interpreter for the installed clink-repl and clink-vim scripts
    python3
  ];

  # Clink refuses to run unless `which vim` succeeds
  postInstall = ''
    wrapProgram $out/bin/clink \
      --suffix PATH : ${
        lib.makeBinPath [
          vim
          which
        ]
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  # Upstream reports the last tag
  preVersionCheck = ''
    version=${lib.head (lib.splitString "-" finalAttrs.version)}
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Modern re-implementation of Cscope";
    longDescription = ''
      When working in a large, complex C/C++ code base, an invaluable
      navigation tool is Cscope. However, Cscope is showing its age
      and has some issues that prevent it from being the perfect
      assistant. Clink aims to bring the Cscope experience into the
      twenty-first century.
    '';
    homepage = "https://github.com/Smattr/clink";
    changelog = "https://github.com/Smattr/clink/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "clink";
    platforms = lib.platforms.unix;
  };
})
