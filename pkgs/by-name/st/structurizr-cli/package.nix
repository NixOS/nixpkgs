{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  coreutils,
  findutils,
  gnused,
  graphviz,
  jre,
  gradle,
  makeBinaryWrapper,
  gitMinimal,
  runCommand,
  versionCheckHook,
  zip,
}:

let
  # The static site template is loaded at runtime from the classpath resource
  # /static.zip. Upstream gitignores src/main/resources/static.zip and generates
  # it with ui.sh, which copies assets out of a sibling structurizr/ui checkout,
  # so it is absent from the git tree and has to be rebuilt here.
  #
  # This revision is the one whose assets match the 2025.05.28 release
  # byte-for-byte; bump it alongside version.
  ui = fetchFromGitHub {
    owner = "structurizr";
    repo = "ui";
    rev = "b9b0765c69544be2afcc1033657ee4122cc2e76b";
    hash = "sha256-4up+aMBETdDTFwowtj+VPz2oOxim4zuKO+Kvzq9pULE=";
  };
in
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

    # Reproduce upstream's ui.sh, which is not part of the build and relies on a
    # sibling structurizr/ui checkout. Keep this asset list in sync with it.
    mkdir -p static/js static/css
    for f in jquery-3.6.3.min.js bootstrap-3.3.7.min.js lodash-4.17.21.js \
             backbone-1.4.1.js joint-3.6.5.js structurizr.js structurizr-util.js \
             structurizr-ui.js structurizr-workspace.js structurizr-diagram.js \
             structurizr-quick-navigation.js structurizr-navigation.js \
             structurizr-tooltip.js structurizr-embed.js; do
      cp ${ui}/src/js/"$f" static/js/
    done
    for f in bootstrap-3.3.7.min.css joint-3.6.5.css structurizr-diagram.css \
             structurizr-static.css structurizr-static-dark.css; do
      cp ${ui}/src/css/"$f" static/css/
    done
    cp ${ui}/src/static.html static/index.html

    # Normalise mtimes so the archive is reproducible; SOURCE_DATE_EPOCH is
    # 1980-01-01, which is also the earliest timestamp zip can represent.
    chmod -R u+w static
    find static -exec touch -d "@$SOURCE_DATE_EPOCH" {} +
    (cd static && zip -X -q -r ../src/main/resources/static.zip .)
    rm -rf static
  '';

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
    gitMinimal
    zip
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
          graphviz
          jre
        ]
      }"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  # versionCheckHook passes even when the static site template is missing, which
  # is how that breakage shipped unnoticed; exercise a real export instead.
  passthru.tests.static-export =
    runCommand "structurizr-cli-static-export"
      {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      }
      ''
        cat > workspace.dsl <<'DSL'
        workspace {
          model {
            u = person "User"
            s = softwareSystem "System"
            u -> s "uses"
          }
          views {
            systemContext s {
              include *
              autoLayout
            }
          }
        }
        DSL

        structurizr-cli export -workspace workspace.dsl -format static -output site

        test -f site/index.html
        test -f site/workspace.js
        test -f site/js/structurizr-diagram.js
        test -f site/css/structurizr-static.css

        touch $out
      '';

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
