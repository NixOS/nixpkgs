{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  cmake,
  libllvm,
  libclang,
  sqlite,
  xxd,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clink";
  version = "2024.12.07-unstable-2025-06-25";

  src = fetchFromGitHub {
    owner = "Smattr";
    repo = "clink";
    rev = "61b9fe923c90c5d291c6f60f4eda76b87a3d4c04";
    hash = "sha256-SMwjMK5dULY8KT2ba5HBqzAw7O21k23QK0F6PKqCMGY=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    find . -type f -name '*.py' -exec sed -i "s|#!/usr/bin/env python3|#!${python3}/bin/python3|" {} \;
    find . -type f -name 'CMakeLists.txt' -exec sed -i "s|/usr/bin/env|${coreutils}/bin/env|g" {} \;
  '';

  nativeBuildInputs = [
    cmake
    libllvm
    libclang
    sqlite
    xxd
    python3
    (python3.withPackages (ps: with ps; [ pytest ]))
  ];

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
    changelog = "https://github.com/Smattr/clink/blob/main/CHANGELOG.rst";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "clink";
    platforms = lib.platforms.all;
  };
})
