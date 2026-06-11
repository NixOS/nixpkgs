{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}: let
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "skyhook-io";
    repo = "radar";
    tag = "v${version}";
    hash = "sha256-LT9OThOevyH5mfPI1+/RH2roQfz2jMVBBXVHfhmDxNA=";
  };

  frontend = buildNpmPackage {
    pname = "radar-web";
    inherit version src;

    npmDepsHash = "sha256-HFDTj/9jwYkzdiEZh83UB82ufsJ7BeWVdpuBHfNegLA=";
    npmDepsFetcherVersion = 2;

    # Upstream's lockfile entry for the deprecated @types/diff stub lacks
    # `resolved`/`integrity`, so Nix's offline fetcher skips it and the install
    # fails with ETARGET. Backfill the registry metadata. buildNpmPackage feeds
    # this same postPatch to fetchNpmDeps, so both stay consistent.
    postPatch = ''
      sed -i '/"web\/node_modules\/@types\/diff": {/a\      "resolved": "https://registry.npmjs.org/@types/diff/-/diff-8.0.0.tgz",\n      "integrity": "sha512-o7jqJM04gfaYrdCecCVMbZhNdG6T1MHg/oQoRFdERLV+4d+V7FijhiEAbFu0Usww84Yijk9yH58U4Jk4HbtzZw==",' \
        package-lock.json
    '';

    npmWorkspace = "web";

    installPhase = ''
      runHook preInstall
      cp -r web/dist "$out"
      runHook postInstall
    '';
  };
in
  buildGoModule (finalAttrs: {
    pname = "radar";
    inherit version src;

    vendorHash = "sha256-Dg7Dhxt9Yc31RrKNsPRyKZqLXKW++vBjOT8yJT9MhP0=";

    subPackages = ["cmd/explorer"];

    preBuild = ''
      cp -r ${frontend}/. internal/static/dist/
    '';

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${finalAttrs.version}"
    ];

    postInstall = ''
      mv "$out/bin/explorer" "$out/bin/kubectl-radar"
    '';

    versionCheckProgramArg = ["version"];
    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    doInstallCheck = true;

    passthru = {
      inherit frontend;
      updateScript = nix-update-script {};
    };

    meta = {
      description = "Local-first Kubernetes visibility: topology, event timeline, and service traffic";
      mainProgram = "kubectl-radar";
      homepage = "https://github.com/skyhook-io/radar";
      changelog = "https://github.com/skyhook-io/radar/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.asl20;
      maintainers = [lib.maintainers.gaupee];
      platforms = lib.platforms.unix;
    };
  })
