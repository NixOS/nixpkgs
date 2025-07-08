{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  rustpython,
  cmake,
  xxd,
  libllvm,
  libclang,
  sqlite,
  python3,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clink";
  version = "2024.12.07-unstable-2026-09-11";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Smattr";
    repo = "clink";
    rev = "ad530fffe3f65df8c464f697d205c9c28d996cae";
    hash = "sha256-QEVDgByQV26ershttx0gDMqkssKKPLcyI6oRAHGBFQ4=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace clink/src/{clink-repl,*.py} \
      --replace-fail '#!/usr/bin/env python3' '#!${lib.getExe rustpython}'

    find . -type f -name 'CMakeLists.txt' \
      -exec sed -i "s|/usr/bin/env|${lib.getExe' coreutils "env"}|g" {} \;

    find . -type f -name '*.py' \
      -exec sed -i "s|#!/usr/bin/env python3|#!${lib.getExe rustpython}|" {} \;
  '';

  nativeBuildInputs = [
    cmake
    xxd
    libllvm
    sqlite
    rustpython
    (python3.withPackages (ps: with ps; [ pytest ]))
  ];

  buildInputs = [
    libclang
    sqlite
  ];

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
    platforms = lib.platforms.all;
  };
})
