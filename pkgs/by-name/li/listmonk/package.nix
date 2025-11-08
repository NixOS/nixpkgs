{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  stuffbin,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "listmonk";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "listmonk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rb0/T7I6yLGJBXikOHuXwDdW20nFXpssXfgViHSIIOU=";
  };

  vendorHash = "sha256-bFUWjaaFHB2pnGHBsvUBS2icQkMrB/CfXFa+3vGFFvU=";

  nativeBuildInputs = [
    stuffbin
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.versionString=${finalAttrs.version}"
    "-X \"main.buildString=v${finalAttrs.version} (${stdenv.hostPlatform.system})\""
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/listmonk
  '';

  # Run stuffbin to stuff the frontend and the static in the binary.
  postFixup =
    let
      vfsMappings = [
        "config.toml.sample"
        "schema.sql"
        "queries.sql"
        "permissions.json"
        "static/public:/public"
        "static/email-templates"
        "${finalAttrs.passthru.frontend}:/admin"
        "i18n:/i18n"
      ];
    in
    ''
      stuffbin -a stuff -in $out/bin/listmonk -out $out/bin/listmonk \
        ${lib.concatStringsSep " " vfsMappings}
    '';

  passthru = {
    frontend = callPackage ./frontend.nix { inherit (finalAttrs) meta version src; };
    tests = { inherit (nixosTests) listmonk; };
    updateScript = nix-update-script {
      extraArgs = [
        "-s"
        "frontend"
      ];
    };
  };

  meta = {
    description = "High performance, self-hosted, newsletter and mailing list manager with a modern dashboard";
    mainProgram = "listmonk";
    homepage = "https://github.com/knadh/listmonk";
    changelog = "https://github.com/knadh/listmonk/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      raitobezarius
      hougo
    ];
    license = lib.licenses.agpl3Only;
  };
})
