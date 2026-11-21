{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  stuffbin,
  nixosTests,
  nix-update-script,
  bun,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "listmonk";
  version = "7.0.0-beta.2";

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "listmonk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JpbeQjn2Z3QLTyp1tKh//n4YE+GjA+ea/+nh/CACFV8=";
  };

  vendorHash = "sha256-IL3LmeeqIb2q/Z1Hlmprbw1KxoZS1h0vpVDjjD8MeqA=";

  node_modules = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/static/admin";

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-1zIc6XslRCLfC7A8MwHO5kvPUFWAF81F4XJkBRStLDg=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    stuffbin
    bun
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.versionString=${finalAttrs.version}"
    "-X \"main.buildString=v${finalAttrs.version} (${stdenv.hostPlatform.system})\""
  ];

  postConfigure = ''
    cp -R ${finalAttrs.node_modules}/. static/admin/
  '';

  postBuild = ''
    pushd static/admin
    bun ./build.mjs
    popd
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/listmonk
  '';

  # Run stuffbin to stuff the frontend and the static in the binary.
  postFixup =
    let
      vfsMappings = [
        "config.toml.sample"
        "schema.sql"
        "queries"
        "permissions.json"
        "static/public:/public"
        "static/admin/views:/admin/views"
        "static/admin/partials:/admin/partials "
        "static/admin/dist:/admin/static"
        "static/admin/i18n.txt:/admin/i18n.txt"
        "static/email-templates"
        "i18n:/i18n"
      ];
    in
    ''
      stuffbin -a stuff -in $out/bin/listmonk -out $out/bin/listmonk \
        ${lib.concatStringsSep " " vfsMappings}
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) listmonk; };
    updateScript = nix-update-script {
      extraArgs = [
        "-s"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "High performance, self-hosted, newsletter and mailing list manager with a modern dashboard";
    mainProgram = "listmonk";
    homepage = "https://github.com/knadh/listmonk";
    changelog = "https://github.com/knadh/listmonk/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      hougo
    ];
    license = lib.licenses.agpl3Only;
  };
})
