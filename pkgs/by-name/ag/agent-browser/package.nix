{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  rustPlatform,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  coreutils,
  geist-font,
  nix-update-script,
  which,
  writableTmpDirAsHomeHook,
}:
let
  pnpm = pnpm_11;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agent-browser";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WIg6WAnk3728NrZVh8JYtu2iRoHi8lYT2e5CDgOg2Sc=";
  };

  sourceRoot = "${finalAttrs.src.name}/cli";

  cargoHash = "sha256-f+7fTDs/irnf/6jCmSlSKaIaVAuqmTvjhW/vBT5gBKM=";

  # Place the pre-built dashboard where RustEmbed expects it
  postUnpack = ''
    chmod u+w source/packages/dashboard
    cp -r ${finalAttrs.passthru.dashboard} source/packages/dashboard/out
  '';

  postPatch = ''
    # `which_exists` spawns the external `which` binary at runtime to probe
    # for optional tools; pin it to an absolute store path.
    substituteInPlace src/doctor/helpers.rs src/install.rs \
      src/native/cdp/chrome.rs src/native/cdp/lightpanda.rs --replace-fail \
      '"which"' '"${lib.getExe which}"'

    substituteInPlace src/native/browser.rs src/native/cdp/obscura.rs \
      --replace-fail '"/bin/sleep"' '"${lib.getExe' coreutils "sleep"}"'
    substituteInPlace src/native/e2e_tests.rs \
      --replace-fail '"/bin/false"' '"${lib.getExe' coreutils "false"}"'
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  # Some tests use a shared state that makes them flaky when run concurrently.
  dontUseCargoParallelTests = true;

  # https://github.com/vercel-labs/agent-browser/blob/v0.39.1/cli/src/install.rs#L401-L411
  checkFlags = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    "--skip=install_rejects_an_invalid_explicit_ca_before_network_or_daemon"
  ];

  __darwinAllowLocalNetworking = true;

  # The `skills` subcommand looks for `skills/` and `skill-data/` next to
  # `bin/`, relative to the canonical exe path. See cli/src/skills.rs.
  postInstall = ''
    cp -r ../skills $out/skills
    cp -r ../skill-data $out/skill-data
  '';

  passthru = {
    # The Rust CLI embeds the dashboard UI via RustEmbed at compile time.
    # Build the Next.js static export so it can be placed at the expected path.
    dashboard = stdenv.mkDerivation (finalAttrs': {
      pname = "agent-browser-dashboard";
      inherit (finalAttrs) version src;

      nativeBuildInputs = [
        nodejs
        pnpm
        pnpmConfigHook
      ];

      __darwinAllowLocalNetworking = true;

      pnpmDeps = fetchPnpmDeps {
        pname = "agent-browser-dashboard";
        inherit (finalAttrs') version src;
        inherit pnpm;
        pnpmWorkspaces = [ "dashboard" ];
        fetcherVersion = 4;
        hash = "sha256-iaZzDTeRzz3NocNNypzsHfJthyhVT2EA7wNnu4kbY30=";
      };

      pnpmWorkspaces = [ "dashboard" ];

      # Replace Google Fonts fetch with a local font from nixpkgs since the
      # Nix sandbox has no network access.
      postPatch = ''
        substituteInPlace packages/dashboard/src/app/layout.tsx --replace-fail \
          '{ Geist } from "next/font/google"' \
          'localFont from "next/font/local"'

        substituteInPlace packages/dashboard/src/app/layout.tsx --replace-fail \
          'Geist({ subsets: ["latin"], variable: "--font-sans" })' \
          'localFont({ src: "./Geist-Regular.otf", variable: "--font-sans" })'

        cp "${geist-font}/share/fonts/opentype/Geist-Regular.otf" \
          packages/dashboard/src/app/Geist-Regular.otf
      '';

      buildPhase = ''
        runHook preBuild
        pnpm --filter dashboard build
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        cp -r packages/dashboard/out $out
        runHook postInstall
      '';
    });
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "dashboard"
      ];
    };
  };

  meta = {
    description = "Headless browser automation CLI for AI agents";
    homepage = "https://github.com/vercel-labs/agent-browser";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      baptiste0928
      codgician
    ];
    mainProgram = "agent-browser";
  };
})
