{
  lib,
  sbt,
  makeWrapper,
  boehmgc,
  libunwind,
  re2,
  llvmPackages,
  zlib,
}:

sbt.overrideAttrs (previousAttrs: {
  nativeBuildInputs = (previousAttrs.nativeBuildInputs or [ ]) ++ [ makeWrapper ];

  # sbtn is absent on platforms upstream ships no native client for, and a
  # --client session needs the same toolchain as the launcher.
  postFixup = (previousAttrs.postFixup or "") + ''
    for program in sbt sbtn; do
      [ -e "$out/bin/$program" ] || continue

      wrapProgram "$out/bin/$program" \
        --set CLANG_PATH      "${llvmPackages.clang}/bin/clang" \
        --set CLANGPP_PATH    "${llvmPackages.clang}/bin/clang" \
        --set CPATH           "${
          lib.makeSearchPathOutput "dev" "include" [
            re2
            zlib
            boehmgc
            libunwind
            llvmPackages.libcxx
          ]
        }/c++/v1" \
        --set LIBRARY_PATH    "${
          lib.makeLibraryPath [
            re2
            zlib
            boehmgc
            libunwind
            llvmPackages.libcxx
          ]
        }" \
        --set NIX_CFLAGS_LINK "-lc++"
    done
  '';

  meta = previousAttrs.meta // {
    description = previousAttrs.meta.description + ", with the Scala Native toolchain";
  };
})
