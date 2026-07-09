{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  dart-sass,
  makeBinaryWrapper,
  python313,
  ffmpeg,
  unar,
  nixosTests,
  nix-update-script,
}:
let
  python = python313.withPackages (ps: [
    ps.lxml
    ps.numpy
    ps.pillow
    ps.psycopg2
    ps.setuptools
    ps.webrtcvad
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bazarr";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "morpheus65535";
    repo = "bazarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r3H0JEcGYzQOTHVR/zONmtOIF+LnJd+qn2pcAj8vdOA=";
  };

  npmRoot = "frontend";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/frontend";
    hash = "sha256-cb++eqVtKZer9B1rwJ9WR4mZImnASeFU2MojgXAPWf4=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    dart-sass
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pushd frontend
    # sass-embedded's bundled Dart compiler won't run in the sandbox; use nixpkgs' dart-sass.
    # https://github.com/sass/embedded-host-node/issues/334
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["dart-sass"];'
    npm run build
    popd
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/bazarr/frontend
    cp -r bazarr bazarr.py custom_libs libs migrations $out/share/bazarr/
    cp -r frontend/build $out/share/bazarr/frontend/build

    printf '%s' "${finalAttrs.version}" > $out/share/bazarr/VERSION

    printf '%s' "${
      lib.generators.toKeyValue { } {
        updatemethod = "External";
        updatemethodmessage = "Bazarr is managed by Nix. Update it through your system configuration.";
        packageversion = finalAttrs.version;
        packageauthor = "nixpkgs";
      }
    }" > $out/share/bazarr/package_info

    makeWrapper ${lib.getExe python} $out/bin/bazarr \
      --add-flags $out/share/bazarr/bazarr.py \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          unar
        ]
      }

    runHook postInstall
  '';

  passthru = {
    tests.smoke-test = nixosTests.bazarr;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Subtitle manager for Sonarr and Radarr";
    homepage = "https://www.bazarr.media/";
    changelog = "https://github.com/morpheus65535/bazarr/releases/tag/v${finalAttrs.version}";
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
