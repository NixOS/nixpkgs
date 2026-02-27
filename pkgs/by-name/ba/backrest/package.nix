{
  buildGo125Module,
  fetchFromGitHub,
  gzip,
  fetchurl,
  iana-etc,
  lib,
  libredirect,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  restic,
  stdenv,
  util-linux,
  makeBinaryWrapper,
  nix-update-script,
  _experimental-update-script-combinators,
}:
let
  pname = "backrest";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "garethgeorge";
    repo = "backrest";
    tag = "v${version}";
    hash = "sha256-wtvHIR0Bag8tJVWEwEq8PcT1zHsD670pIidp/OCLk7g=";
  };

  # we need to pin the inlang plugins to specific versions because
  # the remote ones are not pinned and we can't fetch them in the sandbox.
  inlang-plugins = lib.mapAttrs (remote: info: fetchurl { inherit (info) url hash; }) (
    lib.importJSON ./inlang-plugins.json
  );

  pnpmDepsHash-webui =
    if stdenv.hostPlatform.isLinux then
      "sha256-i+mirOEvzo4XvlPxGeNx7Em5k97b3vfRnXact1P1SeY="
    else
      "sha256-RzwOmY0NKrmT6Spw+2Ce1xYJoFRJwIvtl4gkDu/+0ck=";

  frontend = stdenv.mkDerivation (finalAttrs: {
    inherit version;
    pname = "${pname}-webui";
    src = "${src}/webui";

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_9
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_9;
      fetcherVersion = 1;
      hash = pnpmDepsHash-webui;
    };

    postPatch = ''
      # Replace remote inlang plugins with local ones
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (remote: local: ''
          substituteInPlace project.inlang/settings.json \
            --replace-fail "${remote}" "${local}"
        '') inlang-plugins
      )}
    '';

    buildPhase = ''
      runHook preBuild
      export BACKREST_BUILD_VERSION=${version}
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r dist/* $out
      runHook postInstall
    '';
  });
in
buildGo125Module (finalAttrs: {
  inherit
    pname
    src
    version
    frontend
    ;

  postPatch = ''
    sed -i -e \
      '/func installRestic(targetPath string) error {/a\
        return fmt.Errorf("installing restic from an external source is prohibited by nixpkgs")' \
      internal/resticinstaller/resticinstaller.go
  '';

  proxyVendor = true;
  vendorHash = "sha256-NC2VohNkU5MKUSguY83/j4Fb1CkZajw3gzHm4qnj5gM=";

  subPackages = [ "cmd/backrest" ];

  nativeBuildInputs = [
    gzip
    makeBinaryWrapper
  ];

  preBuild = ''
    mkdir -p ./webui/dist
    cp -r ${finalAttrs.frontend}/* ./webui/dist

    go generate -skip="npm" ./...
  '';

  nativeCheckInputs = [
    util-linux
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libredirect.hook ];

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    })
    ./update-inlang-plugins.sh
  ];

  checkFlags =
    let
      skippedTests = [
        "TestMultihostIndexSnapshots"
        "TestRunCommand"
        "TestSnapshot"
        "TestServeIndexGzip" # e2e test requires networking
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "TestBackup" # relies on ionice
        "TestCancelBackup"
        "TestFirstRun" # e2e test requires networking
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  preCheck = ''
    # Use restic from nixpkgs, otherwise download fails in sandbox
    export BACKREST_RESTIC_COMMAND="${restic}/bin/restic"
    export HOME=$(pwd)
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/backrest \
      --set-default BACKREST_RESTIC_COMMAND "${lib.getExe restic}"
  '';

  meta = {
    description = "Web UI and orchestrator for restic backup";
    homepage = "https://github.com/garethgeorge/backrest";
    changelog = "https://github.com/garethgeorge/backrest/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      iedame
      alexandru0-dev
    ];
    mainProgram = "backrest";
    platforms = lib.platforms.unix;
  };
})
