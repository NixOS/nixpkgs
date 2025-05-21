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
  version = "0.24.2";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-DWOJ6+lUTbOzMLsfTDNZfhgNomajNCnNi7U1A+tqXm4=";
  };

  protobufsGenerated = stdenvNoCC.mkDerivation {
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
    outputHash = "sha256-u+Wq/fXvWTjXdhC2h6RCsn7pjdFJ+gUdTPRvrn9cZ+k=";
  };

  frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "memos-web";
    inherit version src;
    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/web";
      hash = "sha256-lopCa7F/foZ42cAwCxE+TWAnglTZg8jY8eRWmeck/W8=";
    };
    pnpmRoot = "web";
    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];
    preBuild = ''
      cp -r {${protobufsGenerated},.}/web/src/types/proto
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
  inherit version src;

  vendorHash = "sha256-hdL4N0tg/lYGTeiKl9P2QsV8HTxlvHfsSqsqq/C0cg8=";

  preBuild = ''
    rm -rf server/router/frontend/dist
    cp -r ${frontend} server/router/frontend/dist
    cp -r {${protobufsGenerated},.}/proto/gen
  '';

  patches = [
    # to be removed in next release (test was removed upstream as part of a bigger commit)
    ./nixbuild-check.patch
  ];

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
    maintainers = with lib.maintainers; [
      indexyz
      kuflierl
    ];
    license = lib.licenses.mit;
    mainProgram = "memos";
  };
}
