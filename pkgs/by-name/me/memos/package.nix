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
  version = "0.25.1";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-5CeeOpdXs+6Vus4er8JVhJM0a7BKtGsF4SPdOoX5xQk=";
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
    outputHash = "sha256-BOBnNcBp/vjTaS7N1z5kRWZoKokJXEMNs5rS32ZBtKU=";
  };

  memos-web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "memos-web";
    inherit version src;
    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/web";
      fetcherVersion = 1;
      hash = "sha256-qY3jPbdEy+lWoBV/xKNTGQ58xvcoBoG0vPwN5f9+wj4=";
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

  vendorHash = "sha256-+v2OElo2ZC0OEhNsNe23J0PR0y1opm/HckW+vUmJ8e4=";

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
