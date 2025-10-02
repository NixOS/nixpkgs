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
  runCommand,
  fetchFromGitHub,
  python3,
  nodejs,
}:
let
  # boring-sys expects the static libraries in build/ instead of lib/
  boringssl-wrapper = runCommand "boringssl-wrapper" { } ''
    mkdir $out
    cd $out
    ln -s ${boringssl.out}/lib build
    ln -s ${boringssl.dev}/include include
  '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libsignal-node";
  version = "0.81.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "libsignal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SOQyps+iGVQ3RWPLmQHzXwmMwmR1PrGIbViCmNg60P4=";
  };

  cargoHash = "sha256-O4v9GgNrs4+HpfgoHh6YLy4dNF1LrF1ZS50RaEHh1iM=";

  npmRoot = "node";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-KvMEQ9nJunqF2CDjiP3s3CMoeF+nbUpZDzSIMsImbPg=";
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
  env.BORING_BSSL_PATH = "${boringssl-wrapper}";
  env.NIX_LDFLAGS = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";

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
    npm run build -- --copy-to-prebuilds
    popd

    runHook postBuild
  '';

  dontCargoInstall = true;
})
