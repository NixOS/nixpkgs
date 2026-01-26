{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  buildNpmPackage,
  geist-font,
  nix-update-script,
}:

rustPlatform.buildRustPackage (
  finalAttrs:

  let
    frontend = buildNpmPackage {
      pname = "oxdraw-frontend";
      inherit (finalAttrs) version src;

      sourceRoot = "source/frontend";

      patches = [
        # By default, NextJS tries to fetch fonts from google
        # Because of sandboxing, that fails, so we use the
        # font from nixpkgs
        ./font-lookup.patch
      ];

      buildPhase = ''
        runHook preBuild
        cp ${geist-font}/share/fonts/opentype/Geist{,Mono}-Regular.otf .
        npm run build
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        cp -r out $out
        runHook postInstall
      '';

      npmDepsHash = "sha256-Yyox/x78spQqCJDJkPVuzfeAbtd/fdyihDHudIqruo4=";
    };
  in
  {
    pname = "oxdraw";
    version = "0.2.0";

    src = fetchFromGitHub {
      owner = "RohanAdwankar";
      repo = "oxdraw";
      tag = "v${finalAttrs.version}";
      hash = "sha256-2B0G5aWRtUvZiCsX1fOw6M2UhShZaDj11r/fXCemGVc=";
    };

    cargoHash = "sha256-YedNESkXKbfl7FWea7VpDR+59b9WLtZ7GNcyJ7D9yPg=";

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];

    preBuild = ''
      rm build.rs
    '';

    env.OXDRAW_BUNDLED_WEB_DIST = frontend;

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Diagram as Code Tool Written in Rust with Draggable Editing";
      homepage = "https://github.com/RohanAdwankar/oxdraw";
      changelog = "https://github.com/RohanAdwankar/oxdraw/releases/tag/${finalAttrs.version}";
      license = [
        lib.licenses.mit
      ];
      maintainers = with lib.maintainers; [
        blenderfreaky
      ];
      mainProgram = "oxdraw";
      platforms = lib.platforms.linux;
    };
  }
)
