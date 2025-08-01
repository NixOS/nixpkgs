{
  fetchFromGitHub,
  buildGoModule,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  lib,
  pnpm,
  buf,
  cacert,
  grpc-gateway,
  protoc-gen-go,
  protoc-gen-go-grpc,
  protoc-gen-validate,
}:
let
  version = "0.25.0";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-M1o7orU4xw/t9PjSFXNj7tiYTarBv7kIIj8X0r3QD8s=";
  };

  memos-protobuf-gen = stdenvNoCC.mkDerivation {
    name = "memos-protobuf-gen";
    inherit src;

    nativeBuildInputs = [
      buf
      cacert
      grpc-gateway
      protoc-gen-go
      protoc-gen-go-grpc
      protoc-gen-validate
    ];

    buildPhase = ''
      runHook preBuild
      pushd proto
      HOME=$TMPDIR buf generate
      popd
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/{proto,web/src/types}
      cp -r {.,$out}/proto/gen
      cp -r {.,$out}/web/src/types/proto
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-lV92s/KLzWs/KSLbsb61FaA9+PEDMLshl/srDcjdRcU=";
  };

  memos-web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "memos-web";
    inherit version src;
    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/web";
      fetcherVersion = 1;
      hash = "sha256-TEWaFWFQ0sHdgfFFvolnwoa4hTaFkzqqyFep56Cevp4=";
    };
    pnpmRoot = "web";
    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];
    preBuild = ''
      cp -r {${memos-protobuf-gen},.}/web/src/types/proto
    '';
    buildPhase = ''
      runHook preBuild
      pnpm -C web build
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      cp -r web/dist $out
      runHook postInstall
    '';
  });
in
buildGoModule {
  pname = "memos";
  inherit
    version
    src
    memos-web
    memos-protobuf-gen
    ;

  vendorHash = "sha256-xiBxnrjJsskRCcUBGKnrc5s5tuhMFSqRoELcr5ww/XU=";

  preBuild = ''
    rm -rf server/router/frontend/dist
    cp -r ${memos-web} server/router/frontend/dist
    cp -r {${memos-protobuf-gen},.}/proto/gen
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "memos-web"
      "--subpackage"
      "memos-protobuf-gen"
    ];
  };

  meta = {
    homepage = "https://usememos.com";
    description = "Lightweight, self-hosted memo hub";
    changelog = "https://github.com/usememos/memos/releases/tag/${src.rev}";
    maintainers = with lib.maintainers; [
      indexyz
      kuflierl
    ];
    license = lib.licenses.mit;
    mainProgram = "memos";
  };
}
