{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeWrapper,
  net-tools,
  nodejs,
  pnpm,
  pnpmConfigHook,
  stdenvNoCC,
}:

let
  version = "0.63.7";

  src = fetchFromGitHub {
    owner = "pommee";
    repo = "goaway";
    tag = "v${version}";
    hash = "sha256-XNjp9fSMu5AdLnFNsh7Lrf1J06sPZPjvlNFkDa1QDJQ=";
  };

  goaway-web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "goaway-web";
    inherit version src;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/client";
      fetcherVersion = 1;
      hash = "sha256-cJLJMJNDPr73w5IiB1/zIloIdsUhqI+o/JqoKNwNweI=";
    };

    pnpmRoot = "client";

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    buildPhase = ''
      runHook preBuild

      pnpm -C client build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r client/dist $out

      runHook postInstall
    '';

  });
in
buildGo126Module (finalAttrs: {
  pname = "goaway";
  inherit
    version
    src
    goaway-web
    ;

  vendorHash = "sha256-QgacBw+kpGdv8fAPQyndrHTxY1JrxFRf2qCS7etjNfw=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.src.tag}"
    "-X=main.commit=${finalAttrs.src.tag}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  preBuild = ''
    rm -rf client/dist
    cp -r ${goaway-web} client/dist
  '';

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/goaway \
     --prefix PATH : $out/bin:${lib.makeBinPath [ net-tools ]}
  '';

  meta = {
    description = "Lightweight DNS sinkhole written in Go with a modern dashboard client";
    homepage = "https://github.com/pommee/goaway";
    changelog = "https://github.com/pommee/goaway/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "goaway";
  };
})
