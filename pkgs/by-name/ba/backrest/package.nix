{
  buildGoModule,
  fetchurl,
  fetchFromGitHub,
  gzip,
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
}:
let
  pname = "backrest";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "garethgeorge";
    repo = "backrest";
    tag = "v${version}";
    hash = "sha256-yhhY0aWRwfpAGf3UpzYkRI848Y/kpiCjUyjt3udOmJI=";
  };

  inlang-plugin-message-format = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-message-format@4/dist/index.js";
    hash = "sha256-lIZViAHAjrsBgiPFHCBEtsPCP8KowOeJSleIKzT+tso=";
  };

  inlang-plugin-m-function-matcher = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-m-function-matcher@2/dist/index.js";
    hash = "sha256-hYYvYwV5O1a/2a/lNosJbmP7Kuqzi3eZwFFRe+NJnAs=";
  };

  frontend = stdenv.mkDerivation (finalAttrs: {
    inherit version;
    pname = "${pname}-webui";
    src = "${src}/webui";

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_9
    ];

    postPatch = ''
      substituteInPlace project.inlang/settings.json \
        --replace-fail \
          "https://cdn.jsdelivr.net/npm/@inlang/plugin-message-format@4/dist/index.js" \
          "${inlang-plugin-message-format}" \
        --replace-fail \
          "https://cdn.jsdelivr.net/npm/@inlang/plugin-m-function-matcher@2/dist/index.js" \
          "${inlang-plugin-m-function-matcher}"
    '';

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_9;
      fetcherVersion = 3;
      hash = "sha256-6u+rhN0RwQunufZCJKiogImsmSTZR3tGxJZJhUI/x/0=";
    };

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
buildGoModule {
  inherit pname src version;

  postPatch = ''
    sed -i -e \
      '/func installRestic(targetPath string) error {/a\
        return fmt.Errorf("installing restic from an external source is prohibited by nixpkgs")' \
      internal/resticinstaller/resticinstaller.go
  '';

  vendorHash = "sha256-NC2VohNkU5MKUSguY83/j4Fb1CkZajw3gzHm4qnj5gM=";
  proxyVendor = true;

  nativeBuildInputs = [
    gzip
    makeBinaryWrapper
  ];

  preBuild = ''
    mkdir -p ./webui/dist
    cp -r ${frontend}/* ./webui/dist

    go generate -skip="npm" ./...
  '';

  nativeCheckInputs = [
    util-linux
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libredirect.hook ];

  checkFlags =
    let
      skippedTests = [
        "TestMultihostIndexSnapshots"
        "TestRunCommand"
        "TestSnapshot"
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
    ${gzip}/bin/gzip -c /dev/null > webui/dist/index.html.gz
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  postCheck = ''
    rm webui/dist/index.html.gz
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
    maintainers = with lib.maintainers; [ iedame ];
    mainProgram = "backrest";
    platforms = lib.platforms.unix;
  };
}
