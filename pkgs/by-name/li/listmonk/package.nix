{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  stuffbin,
  nixosTests,
  pinData ? (lib.importJSON ./pin.json),
}:
let
  inherit (pinData)
    version
    hash
    vendorHash
    yarnHash
    ;
in
buildGoModule (finalAttrs: {
  pname = "listmonk";
  inherit version;

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "listmonk";
    rev = "v${version}";
    inherit hash;
  };

  inherit vendorHash;

  nativeBuildInputs = [
    stuffbin
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.versionString=${version}"
    "-X \"main.buildString=v${version} (${stdenv.hostPlatform.system})\""
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
    frontend = callPackage ./frontend.nix {
      inherit yarnHash;
      inherit (finalAttrs) meta version src;
    };
    tests = { inherit (nixosTests) listmonk; };
  };

  meta = {
    description = "High performance, self-hosted, newsletter and mailing list manager with a modern dashboard";
    mainProgram = "listmonk";
    homepage = "https://github.com/knadh/listmonk";
    changelog = "https://github.com/knadh/listmonk/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ raitobezarius ];
    license = lib.licenses.agpl3Only;
  };
})
