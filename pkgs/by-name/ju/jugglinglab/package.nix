{
  lib,
  stdenv,
  maven,
  fetchFromGitHub,
  fetchzip,
  makeWrapper,
  wrapGAppsHook3,
  jre,
  # install example Juggling Lab pattern files
  withPatterns ? false,
  # automatically set the working directory to the directory
  # containing the pattern files for easier access
  withPatternsWorkdir ? withPatterns,
}:

assert withPatternsWorkdir -> withPatterns;

let
  platformName =
    {
      "x86_64-linux" = "linux-x86-64";
      "aarch64-linux" = "linux-aarch64";
      "x86_64-darwin" = "darwin-x86-64";
      "aarch64-darwin" = "darwin-aarch64";
    }
    .${stdenv.system} or null;
in
maven.buildMavenPackage rec {
  pname = "jugglinglab";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "jkboyce";
    repo = "jugglinglab";
    rev = "v${version}";
    hash = "sha256-Y87uHFpVs4A/wErNO2ZF6Su0v4LEvaE9nIysrqFoY8w=";
  };

  patches = [
    # make sure mvnHash doesn't change when maven is updated
    ./fix-default-maven-plugin-versions.patch

    # add some nixpkgs specific logic, so that we don't have to use upstream's
    # wrapper scripts for launching the application in different modes
    ./cli.patch
  ];

  mvnHash = "sha256-1Uzo9nRw+YR/sd7CC9MTPe/lttkRX6BtmcsHaagP1Do=";

  # fix jar timestamps for reproducibility
  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  patterns =
    if withPatterns then
      fetchzip {
        # URL found on https://jugglinglab.org/
        url = "https://storage.googleapis.com/jugglinglab-dl/Patterns-220114.zip";
        hash = "sha256-J9lRNEHWBzZLONOnmonXR1+2Wvk7zNclU6NrDMnHkRE=";
      }
    else
      null;

  installPhase = ''
    runHook preInstall

    install -Dm644 bin/JugglingLab.jar -t $out/share/jugglinglab
    ${lib.optionalString (platformName != null) ''
      install -Dm755 bin/ortools-lib/ortools-${platformName}/* -t $out/lib/ortools-lib
    ''}
    ${lib.optionalString withPatterns ''
      cp -a $patterns $out/share/jugglinglab/patterns;
    ''}

    runHook postInstall
  '';

  # gappsWrapperArgs are set in preFixup
  postFixup = ''
    makeWrapper ${jre}/bin/java $out/bin/jugglinglab \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "-Xss2048k -Djava.library.path=$out/lib/ortools-lib" \
        --add-flags "-jar $out/share/jugglinglab/JugglingLab.jar" \
        ${lib.optionalString withPatternsWorkdir "--set-default JL_WORKING_DIR $out/share/jugglinglab/patterns"}

    makeWrapper $out/bin/jugglinglab $out/bin/jlab \
        --set-default JL_IS_CLI 1
  '';

  meta = with lib; {
    description = "Program to visualize different juggling pattens";
    homepage = "https://jugglinglab.org/";
    license = licenses.gpl2Only;
    mainProgram = "jugglinglab";
    maintainers = with maintainers; [
      wnklmnn
      tomasajt
    ];
    platforms = platforms.all;
  };
}
