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
  version = "0.92.1";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "libsignal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gAXLt0e2k5PA6PgFRQa22oGuNLM7TGkOKQnYtFhn8I8=";
  };

  cargoHash = "sha256-TqYxkkzlbgrc7jkAubz3TsXhcU8Do5IFaLRqSPiZVR0=";

  npmRoot = "node";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-c6Alk2tyloaPAP2Qfgurle0ziVs8vbxb2klKJZaGlaQ=";
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
