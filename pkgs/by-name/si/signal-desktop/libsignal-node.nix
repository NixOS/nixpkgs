{
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
  version = "0.88.2";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "libsignal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hHBxHvAaJ3clCjFwKbyavO1ixe9k8DLdEa5+2AWy+Kk=";
  };

  cargoHash = "sha256-wV9gKdxOcgW1M/cEbRhre9ReDBX+TgQbxVBw1cVZwGY=";

  npmRoot = "node";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-lAS45lXz8gAI96Nge1RdF4zPuOz/Z/8L1EMgob1lUZU=";
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
