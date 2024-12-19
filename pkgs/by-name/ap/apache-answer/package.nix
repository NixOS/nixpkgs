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
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-answer";
    rev = "refs/tags/v${version}";
    hash = "sha256-nS3ZDwY221axzo1HAz369f5jWZ/mpCn4r3OPPqjiohI=";
  };

  webui = stdenv.mkDerivation {
    pname = pname + "-webui";
    inherit version src;

    sourceRoot = "${src.name}/ui";

    pnpmDeps = pnpm.fetchDeps {
      inherit src version pname;
      sourceRoot = "${src.name}/ui";
      hash = "sha256-/se6IWeHdazqS7PzOpgtT4IxCJ1WptqBzZ/BdmGb4BA=";
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

  vendorHash = "sha256-nvXr1YAqVCyhCgPtABTOtzDH+FCQhN9kSEhxKw7ipsE=";

  preBuild = ''
    cp -r ${webui}/* ui/build/
  '';

  patches = [
    (fetchpatch {
      url = "https://github.com/apache/incubator-answer/commit/57b0d0e84dd0e0bf3c8a05a38a7f55eddc5f0dda.patch";
      hash = "sha256-TfF+PtrcMYYgNjgU4lGpnshdII8xECTT2L7M26uebn0=";
    })
  ];

  meta = {
    homepage = "https://answer.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
    mainProgram = "answer";
    changelog = "https://github.com/apache/incubator-answer/releases/tag/v${version}";
    description = "Q&A platform software for teams at any scales";
  };
}
