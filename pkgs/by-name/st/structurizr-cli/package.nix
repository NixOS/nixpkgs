{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  coreutils,
  findutils,
  gnused,
  jre,
  gradle,
  makeBinaryWrapper,
  gitMinimal,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "structurizr-cli";
  version = "2025.05.28";

  src = fetchFromGitHub {
    owner = "structurizr";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bypCW7fEfSzVQHhb7wzxQUkXnoDb8QHUsPCpHV7pW/w=";
  };
  strictDeps = true;

  patches =
    let
      # Use `gradle-application-plugin` to generate scripts and dist zip instead of in-house launch script
      # PR at https://github.com/structurizr/cli/pull/175
      commits = [
        # Use `gradle-application-plugin`
        {
          rev = "eb1657c2be62fb493adde954330a70eebd72026a";
          hash = "sha256-B1vqQNHHSOgiRysc5ZkcBB/8YZ1dMjJuFu5uwGRQKWs=";
        }
        # Set JDK target correctly
        {
          rev = "24be5eeec893df5261100913c4e51ca0bd100689";
          hash = "sha256-tj7fNOqKLPvgTYKCRIJlGg1OGyGOmmx0Pj4H8oDPVdU=";
        }
        # Remove unused `git.commit` property
        {
          rev = "2cb1d86c59f210ce32211395570e8dccf138df16";
          hash = "sha256-wswvXJujyPpbvXvL2SOFC4zZLnfskYFdHvzry66vukQ=";
        }
        # Set build data correctly
        {
          rev = "3260d8622a9cf6197d6ab5d9440087dcaac3fbb9";
          hash = "sha256-0zUmg+smxQLZm9wWu3JL1pIXQJcQ1uyQ433C1pDLatQ=";
        }
        # Wrap compatibility into java block
        {
          rev = "1a11940d089a8d70d6e298660c6f5db638cc8d00";
          hash = "sha256-Myj3s7Kc+bQS3iJIZoEyc39pn3DkBOHFu/B9UUPKXf8=";
        }
      ];
    in
    map (
      entry:
      fetchpatch {
        url = "https://github.com/structurizr/cli/commit/${entry.rev}.patch";
        hash = entry.hash;
      }
    ) commits;

  postPatch = ''
    substituteInPlace src/main/resources/build.properties \
      --subst-var-by BUILD_NUMBER "${finalAttrs.version}" \
      --subst-var-by BUILD_DATE "1970-01-01T00:00:00Z"
  '';

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
    gitMinimal
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "installDist";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp -r build/install/structurizr-cli $out/lib/structurizr-cli

    makeBinaryWrapper $out/lib/structurizr-cli/bin/structurizr-cli $out/bin/structurizr-cli \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          findutils
          gnused
          jre
        ]
      }"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Structurizr CLI for publishing C4 architecture diagrams and models";
    homepage = "https://github.com/structurizr/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhemeryck ];
    platforms = lib.platforms.all;
    mainProgram = "structurizr-cli";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
