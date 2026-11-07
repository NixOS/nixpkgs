{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  git,
  gitMinimal,
  makeBinaryWrapper,
  nix-update-script,
  nodejs_24,
  stdenv,
  symlinkJoin,
  versionCheckHook,
  xdg-utils,
}:

buildNpmPackage (finalAttrs: {
  pname = "diffle";
  version = "0.2.10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "moritzwilksch";
    repo = "diffle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0EbIzaQWt+yvxl/3zKmRDnR1M82kiSpr+mJrLG8IDzs=";
  };

  nodejs = nodejs_24;

  npmDepsHash = "sha256-qzq8Z70x6y7Is9H2DeaoA0DaPf2/zqzqjSpTQzTycyk=";

  # `npm pack` would run the `prepack` build script a second time.
  npmPackFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeBinaryWrapper
    versionCheckHook
  ];

  # The test suite builds real repositories with `git`.
  nativeCheckInputs = [
    gitMinimal
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath (
      [ git ]
      # `diffle` opens the browser with `xdg-open` on Linux and `open` on Darwin,
      # where it ships with the system.
      ++ lib.optional stdenv.hostPlatform.isLinux xdg-utils
    ))
  ];

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  checkPhase = ''
    runHook preCheck
    npm test
    runHook postCheck
  '';

  postCheck = ''
    rm -rf node_modules/.vite
  '';

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    # Puts extra tools such as `gh` or language servers on `diffle`'s `PATH`
    # without rebuilding it, e.g.
    # `diffle.withRuntimePackages [ gh rust-analyzer ]`.
    withRuntimePackages =
      runtimePackages:
      symlinkJoin {
        inherit (finalAttrs) pname version meta;
        paths = [ finalAttrs.finalPackage ];
        nativeBuildInputs = [ makeBinaryWrapper ];
        postBuild = ''
          rm $out/bin/diffle
          makeWrapper ${lib.getExe finalAttrs.finalPackage} $out/bin/diffle \
            --prefix PATH : ${lib.makeBinPath runtimePackages}
        '';
      };
  };

  meta = {
    description = "Local Git diff reviewer in the browser";
    homepage = "https://diffle.app";
    changelog = "https://github.com/moritzwilksch/diffle/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      i-al-istannen
      pavelzw
      ytausch
    ];
    mainProgram = "diffle";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
