{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs_24,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  nix-update-script,
}:

let
  pnpm = pnpm_10.override { nodejs = nodejs_24; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ccusage";
  version = "18.0.11";

  src = fetchFromGitHub {
    owner = "ryoppippi";
    repo = "ccusage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EzHFKZVq0okgRumxn6+4rfxDtz0jY6FBoO9eyrGX4ys=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # Permit loopback networking inside the darwin Nix sandbox so unplugin-macros can run during the build
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    nodejs_24
    pnpm
    pnpmConfigHook
  ];

  buildInputs = [
    nodejs_24
  ];

  pnpmWorkspaces = [
    "ccusage"
    "@ccusage/terminal"
    "@ccusage/internal"
  ];

  # Workaround for a bug in pnpm-config-hook.sh: under __structuredAttrs
  # the hook expands $pnpmWorkspaces unquoted and only iterates its first
  # element, so only --filter=<first workspace> is added. Build the full
  # filter list here so all workspaces get installed. Remove once the
  # hook handles structuredAttrs properly.
  pnpmInstallFlags = map (ws: "--filter=${ws}") finalAttrs.pnpmWorkspaces;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-nxrIaSnALwUHTPx8p65Mp6MpSZzINVvbefgsBaz/cTQ=";
  };

  patches = [ ./no-runtime-download.patch ];

  postPatch = ''
    # Skip generate:schema because:
    # - config-schema.json already exists in source
    # - generate:schema uses git commands, but fetchFromGitHub doesn't include .git directory
    substituteInPlace apps/ccusage/package.json \
      --replace-fail '"build": "pnpm run generate:schema && tsdown"' '"build": "tsdown"'
  '';

  buildPhase = ''
    runHook preBuild

    pnpm run --filter ccusage... build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/ccusage}
    cp -r apps/ccusage/dist $out/lib/ccusage/

    ln -s $out/lib/ccusage/dist/index.js $out/bin/ccusage

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for analyzing Claude Code usage from local JSONL files";
    homepage = "https://ccusage.com";
    changelog = "https://github.com/ryoppippi/ccusage/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.cohei ];
    mainProgram = "ccusage";
  };
})
