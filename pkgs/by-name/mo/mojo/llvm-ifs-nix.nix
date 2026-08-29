{
  lib,
  stdenv,
  clangLinux,
}:

# Modular's linker-driver looks up tools/{intel,graviton,mac}/llvm-ifs.stripped
# from @llvm-ifs. Fill that layout with nixpkgs LLVM instead of the Ubuntu-linked
# S3 tarball.
stdenv.mkDerivation {
  pname = "mojo-llvm-ifs";
  inherit (clangLinux) version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/tools/intel" "$out/tools/graviton" "$out/tools/mac"
    for plat in intel graviton mac; do
      ln -s "${clangLinux}/bin/llvm-ifs" "$out/tools/$plat/llvm-ifs.stripped"
      ln -s "${clangLinux}/bin/llvm-readtapi" "$out/tools/$plat/llvm-readtapi.stripped"
    done

    cat >"$out/BUILD.bazel" <<'EOF'
filegroup(
    name = "llvm-ifs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)
EOF
    : >"$out/REPO.bazel"

    runHook postInstall
  '';

  meta = {
    description = "nixpkgs llvm-ifs arranged as Modular's llvm-ifs repository";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
