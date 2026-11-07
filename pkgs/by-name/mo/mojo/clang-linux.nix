{
  lib,
  stdenv,
  llvmPackages_22,
}:

# Layout Modular's bazel/public-patches/clang.BUILD expects, filled from
# nixpkgs LLVM 22 instead of Modular's S3 clang tarball.
let
  clang = llvmPackages_22.clang-unwrapped;
  inherit (llvmPackages_22) llvm lld compiler-rt;
in
stdenv.mkDerivation {
  pname = "mojo-clang-linux";
  inherit (clang) version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/clang"

    link_tool() {
      local name="$1"
      if [ -e "${clang}/bin/$name" ]; then
        ln -s "${clang}/bin/$name" "$out/bin/$name"
      elif [ -e "${llvm}/bin/$name" ]; then
        ln -s "${llvm}/bin/$name" "$out/bin/$name"
      elif [ -e "${lld}/bin/$name" ]; then
        ln -s "${lld}/bin/$name" "$out/bin/$name"
      else
        echo "error: missing clang tool $name" >&2
        exit 1
      fi
    }

    # Copy the driver so getMainExecutable() is this prefix; clang finds
    # ld.lld next to itself (nixpkgs clang lives in a different output from lld).
    real_clang="$(readlink -f "${clang}/bin/clang")"
    cp -a "$real_clang" "$out/bin/clang-22"
    chmod +x "$out/bin/clang-22"
    ln -sfn clang-22 "$out/bin/clang"
    ln -sfn clang-22 "$out/bin/clang++"
    ln -sfn clang-22 "$out/bin/clang-cl"
    ln -sfn clang-22 "$out/bin/clang-cpp"

    for name in \
      clang-format clang-tidy clangd \
      dsymutil ld.lld ld64.lld lld lld-link wasm-ld \
      llvm-ar llvm-as llvm-bitcode-strip llvm-cov llvm-dlltool llvm-dwp \
      llvm-ifs llvm-install-name-tool llvm-lib llvm-nm llvm-objcopy \
      llvm-objdump llvm-otool llvm-profdata llvm-ranlib llvm-readtapi \
      llvm-strip
    do
      link_tool "$name"
    done

    res="$(echo "${clang.lib}"/lib/clang/*)"
    ver="$(basename "$res")"
    if [ "$ver" != 22 ]; then
      echo "error: Modular clang.BUILD pins lib/clang/22, got $ver" >&2
      exit 1
    fi

    cp -a "$res" "$out/lib/clang/$ver"
    chmod -R u+w "$out/lib/clang/$ver"
    mkdir -p \
      "$out/lib/clang/$ver/share" \
      "$out/lib/clang/$ver/lib/x86_64-unknown-linux-gnu" \
      "$out/lib/clang/$ver/lib/aarch64-unknown-linux-gnu" \
      "$out/lib/clang/$ver/lib/darwin"

    for f in "${compiler-rt}"/lib/linux/*; do
      [ -e "$f" ] || continue
      base="$(basename "$f")"
      dest="''${base/-x86_64./.}"
      dest="''${dest/-x86_64/}"
      ln -sfn "$f" "$out/lib/clang/$ver/lib/x86_64-unknown-linux-gnu/$dest"
      # Unused-platform labels still have to exist for Bazel analysis.
      ln -sfn "$f" "$out/lib/clang/$ver/lib/aarch64-unknown-linux-gnu/$dest"
    done

    for n in \
      libclang_rt.asan_osx_dynamic.dylib \
      libclang_rt.tsan_osx_dynamic.dylib \
      libclang_rt.ubsan_osx_dynamic.dylib
    do
      : >"$out/lib/clang/$ver/lib/darwin/$n"
    done

    cp ${./clang.BUILD} "$out/BUILD.bazel"
    # bzlmod local_repository requires one of these; name is taken from MODULE.bazel use.
    : >"$out/REPO.bazel"

    runHook postInstall
  '';

  meta = {
    description = "nixpkgs LLVM 22 arranged as Modular's hermetic clang repository";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
