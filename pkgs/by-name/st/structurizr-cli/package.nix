{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  coreutils,
  findutils,
  gnused,
  jre,
  gradle,
  makeBinaryWrapper,
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

  patches = [
    (fetchpatch2 {
      url = "https://patch-diff.githubusercontent.com/raw/structurizr/cli/pull/175.patch";
      hash = "sha256-Ut9Rma54vb9UYtvHiCf8LI9i3trlCa45/60sRyKdPnQ=";
    })
  ];

  postPatch = ''
    substituteInPlace src/main/resources/build.properties \
      --subst-var-by BUILD_NUMBER "${finalAttrs.version}" \
      --subst-var-by BUILD_DATE "1970-01-01T00:00:00Z"
  '';

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "installDist";

  installPhase = ''
    runHook preInstall

    find build/install/structurizr-cli -type f | while read -r f; do
      rel="$(echo "$f" | sed 's|^build/install/structurizr-cli/||')"
      install -D "$f" "$out/lib/structurizr-cli/$rel"
    done

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

  strictDeps = true;

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
