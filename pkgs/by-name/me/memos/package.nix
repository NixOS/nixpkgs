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
  version = "0.25.2";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-Yag+OxhlWEhWumnB620QREm4G99osKzQNlGN+1YBMTQ=";
  };

  memos-protobuf-gen = stdenvNoCC.mkDerivation {
    pname = "memos-protobuf-gen";
    inherit version src;

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
    outputHash = "sha256-j9jBxhDi1COowOh5sDjOuVJdHf2/RSwZ0cQUD/j2jt0=";
  };

  memos-web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "memos-web";
    inherit version src;
    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/web";
      fetcherVersion = 1;
      hash = "sha256-qvxOY7ASAlYbT5Ju/8b3qiE9KgXkDIj1MZuVH0hmCOA=";
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

  vendorHash = "sha256-Eihp7Kcu8AiPL2VEypxx8+8JwjHI8htoOv69xGrp560=";

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
