{
  buildGoModule,
  lib,
  fetchFromGitHub,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pnpm,
  nodejs,
  fetchpatch,
  stdenv,
}:

buildGoModule rec {
  pname = "apache-answer";
<<<<<<< HEAD
  version = "1.7.1";
=======
  version = "1.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "apache";
    repo = "answer";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QTm/6srSn4oF78795ADpW10bZmyEmqTNezB6JSkS2I4=";
=======
    hash = "sha256-QrLYkGiEDBB4uUzG2yrlEUYXpQxovKFBmGZjLbZiGKk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  webui = stdenv.mkDerivation {
    pname = pname + "-webui";
    inherit version src;

    sourceRoot = "${src.name}/ui";

<<<<<<< HEAD
    pnpmDeps = fetchPnpmDeps {
=======
    pnpmDeps = pnpm.fetchDeps {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      inherit src version pname;
      sourceRoot = "${src.name}/ui";
      fetcherVersion = 1;
      hash = "sha256-6IeLOwsEqchCwe0GGj/4v9Q4/Hm16K+ve2X+8QHztQM=";
    };

    nativeBuildInputs = [
<<<<<<< HEAD
      pnpmConfigHook
      pnpm
=======
      pnpm.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  vendorHash = "sha256-ZZ+6OS967qtstMxdBzDxTU2wvyieZJM+/g9V96rXPVI=";
=======
  vendorHash = "sha256-mWSKoEYj23fy6ix3mK1/5HeGugp1UAUO+iwInXkzgU4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
