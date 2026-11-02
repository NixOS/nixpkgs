{
  clang-tools,
  codechecker-unwrapped,
  cppcheck,
  gcc,
  infer,
  lib,
  libclang,
  makeWrapper,
  symlinkJoin,
  withClang ? false,
  withClangTools ? false,
  withCppcheck ? false,
  withGcc ? false,
  withInfer ? false,
}:

symlinkJoin {
  pname = "codechecker";

  inherit (codechecker-unwrapped) version meta;

  strictDeps = true;
  __structuredAttrs = true;

  paths = [
    codechecker-unwrapped
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postBuild = ''
    wrapProgram "$out/bin/CodeChecker" \
      --prefix PATH : ${
        lib.makeBinPath (
          lib.optional withClang libclang
          ++ lib.optional withClangTools clang-tools
          ++ lib.optional withCppcheck cppcheck
          ++ lib.optional withGcc gcc
          ++ lib.optional withInfer infer
        )
      }
  '';
}
