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
  version = "2024.12.07";

  src = fetchFromGitHub {
    owner = "Smattr";
    repo = "clink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BfKmipoc/dxa7ZYErV+DNV5sIRCvApZdNcIbHYlCwck=";
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

  strctDeps = true;

  nativeBuildInputs = [
    cmake
    xxd
    libllvm
    libclang
    rustpython
    (python3.withPackages (ps: with ps; [ pytest ]))
  ];

  buildInputs = [ sqlite ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

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
    changelog = "https://github.com/Smattr/clink/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "clink";
    platforms = lib.platforms.all;
  };
})
