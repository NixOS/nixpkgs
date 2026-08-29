{
  buildNpmPackage,
  dart-sass,
  fetchFromGitHub,
  ffmpeg,
  lib,
  nix-update-script,
  nixosTests,
  nodejs_22,
  python313Packages,
  unar,
}:
python313Packages.buildPythonApplication (finalAttrs: {
  pname = "bazarr";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "morpheus65535";
    repo = "bazarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r3H0JEcGYzQOTHVR/zONmtOIF+LnJd+qn2pcAj8vdOA=";
  };

  dependencies = with python313Packages; [
    lxml
    numpy
    pillow
    psycopg2
    setuptools
    webrtcvad
  ];

  __structuredAttrs = true;
  dontBuild = true;
  dontWrapPythonPrograms = true;
  pyproject = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/bazarr/frontend
    cp -r bazarr bazarr.py custom_libs libs migrations $out/lib/bazarr/
    cp -r ${finalAttrs.passthru.frontend} $out/lib/bazarr/frontend/build

    printf '%s' "${finalAttrs.version}" > $out/lib/bazarr/VERSION

    printf '%s' "${
      lib.generators.toKeyValue { } {
        updatemethod = "External";
        updatemethodmessage = "Bazarr is managed by Nix. Update it through your system configuration.";
        packageversion = finalAttrs.version;
        packageauthor = "nixpkgs";
      }
    }" > $out/lib/bazarr/package_info

    makeWrapper ${lib.getExe python313Packages.python} $out/bin/bazarr \
      --add-flags $out/lib/bazarr/bazarr.py \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          unar
        ]
      } \
      --prefix PYTHONPATH : ${python313Packages.makePythonPath finalAttrs.passthru.dependencies} \
      --set PYTHONNOUSERSITE true

    runHook postInstall
  '';

  passthru = {
    frontend = buildNpmPackage {
      inherit (finalAttrs) src version;
      pname = "${finalAttrs.pname}-frontend";

      sourceRoot = "${finalAttrs.src.name}/frontend";

      nodejs = nodejs_22;

      npmDepsHash = "sha256-cb++eqVtKZer9B1rwJ9WR4mZImnASeFU2MojgXAPWf4=";

      nativeBuildInputs = [ dart-sass ];

      # sass-embedded's bundled Dart compiler won't run in the sandbox; use nixpkgs' dart-sass.
      # https://github.com/sass/embedded-host-node/issues/334
      preBuild = ''
        substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
          --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["dart-sass"];'
      '';

      installPhase = ''
        runHook preInstall
        mv build $out
        runHook postInstall
      '';

      dontFixup = true;
    };

    tests.smoke-test = nixosTests.bazarr;

    updateScript = nix-update-script {
      extraArgs = lib.cli.toCommandLineGNU { } { subpackage = "frontend"; };
    };
  };

  meta = {
    description = "Subtitle manager for Sonarr and Radarr";
    homepage = "https://www.bazarr.media/";
    changelog = "https://github.com/morpheus65535/bazarr/releases/tag/${finalAttrs.src.tag}";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      connor-grady
      diogotcorreia
    ];
    mainProgram = "bazarr";
    platforms = lib.platforms.unix;
  };
})
