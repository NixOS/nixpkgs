{
  lib,
  stdenv,
  rustPlatform,
  fetchNpmDeps,
  npmHooks,
  protobuf,
  clang,
  gitMinimal,
  cmake,
  boringssl,
  fetchFromGitHub,
  python3,
  nodejs,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libsignal-node";
  version = "0.105.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "libsignal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2eUVHfRO1diz8p5nokppvzS/mIyqPuXJOEmtMyaWBsE=";
  };

  cargoHash = "sha256-+klpfWBHi08UmVceSsd6+ad5uK7CMPOQ1g+6C2ADUwI=";

  npmRoot = "node";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-AxtRlsz4/7SXuZ2DOYjUMHFegEjGTnLX9JoMXHMv3pg=";
  };

  nativeBuildInputs = [
    python3
    protobuf
    nodejs
    clang
    gitMinimal
    cmake
    npmHooks.npmConfigHook
    rustPlatform.bindgenHook
  ];

  env = {
    BORING_BSSL_INCLUDE_PATH = "${boringssl.dev}/include";
    BORING_BSSL_PATH = boringssl;
    NIX_LDFLAGS = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";
  };

  patches = [
    # This is used to strip absolute paths of dependencies to avoid leaking info about build machine. Nix builders
    # already solve this problem by chrooting os this is not needed.
    ./dont-strip-absolute-paths.patch
  ];
  postPatch = ''
    substituteInPlace node/build_node_bridge.py \
      --replace-fail "'prebuilds'" "'$out/lib'" \
      --replace-fail "objcopy = shutil.which('%s-linux-gnu-objcopy' % cargo_target.split('-')[0]) or 'objcopy'" \
                     "objcopy = os.getenv('OBJCOPY', 'objcopy')"
  ''
  + lib.optionalString boringssl.passthru.isShared ''
    substituteInPlace $cargoDepsCopy/*/boring-sys-*/build/main.rs \
      --replace-fail "cargo:rustc-link-lib=static=crypto" "cargo:rustc-link-lib=dylib=crypto" \
      --replace-fail "cargo:rustc-link-lib=static=ssl" "cargo:rustc-link-lib=dylib=ssl"
  '';

  buildPhase = ''
    runHook preBuild

    pushd node
    npm run build -- --copy-to-prebuilds --node-arch ${stdenv.hostPlatform.node.arch}
    popd

    runHook postBuild
  '';

  dontCargoInstall = true;
})
