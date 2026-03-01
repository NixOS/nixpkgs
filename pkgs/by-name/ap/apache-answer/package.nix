{
  buildGoModule,
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  nodejs,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "apache-answer";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "answer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QTm/6srSn4oF78795ADpW10bZmyEmqTNezB6JSkS2I4=";
  };

  webui = stdenv.mkDerivation {
    pname = "apache-answer" + "-webui";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/ui";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) src version pname;
      sourceRoot = "${finalAttrs.src.name}/ui";
      fetcherVersion = 1;
      hash = "sha256-6IeLOwsEqchCwe0GGj/4v9Q4/Hm16K+ve2X+8QHztQM=";
    };

    nativeBuildInputs = [
      pnpmConfigHook
      pnpm
      nodejs
    ];

    buildPhase = ''
      runHook preBuild

      pnpm build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r build/* $out

      runHook postInstall
    '';
  };

  vendorHash = "sha256-ZZ+6OS967qtstMxdBzDxTU2wvyieZJM+/g9V96rXPVI=";

  doCheck = false; # TODO checks are currently broken upstream

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
    "-X main.Commit=${finalAttrs.version}"
  ];

  preBuild = ''
    cp -r ${finalAttrs.webui}/* ui/build/
  '';

  meta = {
    homepage = "https://answer.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      bot-wxt1221
    ];
    platforms = lib.platforms.unix;
    mainProgram = "answer";
    changelog = "https://github.com/apache/answer/releases/tag/v${finalAttrs.version}";
    description = "Q&A platform software for teams at any scales";
  };
})
