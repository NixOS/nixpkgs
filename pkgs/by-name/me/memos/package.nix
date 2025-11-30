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
  version = "0.25.3";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-lAKzPteGjGa7fnbB0Pm3oWId5DJekbVWI9dnPEGbiBo=";
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
    outputHash = "sha256-im9eVhsJ7sIxdYPugUP5Gi/ugr4I1c8aa3UzuArOxp8=";
  };

  memos-web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "memos-web";
    inherit version src;
    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/web";
      fetcherVersion = 1;
      hash = "sha256-k+pykzAiZ72cMMH+6qtnNxjaq4m4QyCQuWvQPbZSZho=";
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

  vendorHash = "sha256-BoJxFpfKS/LByvK4AlTNc4gA/aNIvgLzoFOgyal+aF8=";

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
