{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  rustPlatform,
  nodejs,
  pnpm,
  pnpmConfigHook,
  geist-font,
  nix-update-script,
  which,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    tag = "v${version}";
    hash = "sha256-q3UcFTB8OMOrfx5xcNPtBBAwOxoscwrjGg+y8tdETm0=";
  };

  # The Rust CLI embeds the dashboard UI via RustEmbed at compile time.
  # Build the Next.js static export so it can be placed at the expected path.
  dashboard = stdenv.mkDerivation {
    pname = "agent-browser-dashboard";
    inherit version src;

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpmConfigHook
    ];

    __darwinAllowLocalNetworking = true;

    pnpmDeps = fetchPnpmDeps {
      pname = "agent-browser-dashboard";
      inherit version src;
      pnpmWorkspaces = [ "dashboard" ];
      fetcherVersion = 3;
      hash = "sha256-ldxmXpejqVN/xuWcdLYMwNPc1VZ1rdNwRrumy8Is3N4=";
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
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agent-browser";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/cli";

  cargoHash = "sha256-ENIGFhZ+pXIZvEFUA0No3HpeHtxgJohMgx6F0wNpmO0=";

  # Place the pre-built dashboard where RustEmbed expects it
  postUnpack = ''
    chmod u+w source/packages/dashboard
    cp -r ${dashboard} source/packages/dashboard/out
  '';

  # `which_exists` spawns the external `which` binary at runtime to probe
  # for optional tools; pin it to an absolute store path.
  postPatch = ''
    substituteInPlace src/doctor/helpers.rs src/install.rs --replace-fail \
      '"which"' '"${lib.getExe which}"'
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  __darwinAllowLocalNetworking = true;

  # skills/ contains SKILL.md for tools like Claude Code
  postInstall = ''
    mkdir -p $out/share/agent-browser
    cp -r ../skills $out/share/agent-browser/
  '';

  passthru = {
    inherit dashboard;
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
    maintainers = with lib.maintainers; [ codgician ];
    mainProgram = "agent-browser";
  };
})
