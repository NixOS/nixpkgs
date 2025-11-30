{
  buildGoModule,
  lib,
  fetchFromGitHub,
  pnpm,
  nodejs,
  fetchpatch,
  stdenv,
}:

buildGoModule rec {
  pname = "apache-answer";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "answer";
    tag = "v${version}";
    hash = "sha256-QrLYkGiEDBB4uUzG2yrlEUYXpQxovKFBmGZjLbZiGKk=";
  };

  webui = stdenv.mkDerivation {
    pname = pname + "-webui";
    inherit version src;

    sourceRoot = "${src.name}/ui";

    pnpmDeps = pnpm.fetchDeps {
      inherit src version pname;
      sourceRoot = "${src.name}/ui";
      fetcherVersion = 1;
      hash = "sha256-6IeLOwsEqchCwe0GGj/4v9Q4/Hm16K+ve2X+8QHztQM=";
    };

    nativeBuildInputs = [
      pnpm.configHook
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

  vendorHash = "sha256-mWSKoEYj23fy6ix3mK1/5HeGugp1UAUO+iwInXkzgU4=";

  doCheck = false; # TODO checks are currently broken upstream

  ldflags = [
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
  ];

  preBuild = ''
    cp -r ${webui}/* ui/build/
  '';

  meta = {
    homepage = "https://answer.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      bot-wxt1221
    ];
    platforms = lib.platforms.unix;
    mainProgram = "answer";
    changelog = "https://github.com/apache/answer/releases/tag/v${version}";
    description = "Q&A platform software for teams at any scales";
  };
}
