{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  stuffbin,
  nixosTests,
}:

buildGoModule rec {
  pname = "listmonk";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "listmonk";
    rev = "v${version}";
    hash = "sha256-f6jket2lHw8r5lFkIZ7KurHbWFezNV4YO+9rmZ79WSc=";
  };

  vendorHash = "sha256-sQ9CoYWdZYVdwh/Pszp/JEglvAU2/zJFSZ9jx8Ed/9M=";

  nativeBuildInputs = [
    stuffbin
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/listmonk
  '';

  # Run stuffbin to stuff the frontend and the static in the binary.
  postFixup =
    let
      # See https://github.com/knadh/listmonk/blob/c87715628d8400a9c8ab20369dfadf8ae25afe5e/Makefile#L23-L28
      vfsMappings = [
        "config.toml.sample"
        "schema.sql"
        "queries.sql"
        "permissions.json"
        "static/public:/public"
        "static/email-templates"
        "${passthru.frontend}:/admin"
        "i18n:/i18n"
      ];
    in
    ''
      stuffbin -a stuff -in $out/bin/listmonk -out $out/bin/listmonk \
        ${lib.concatStringsSep " " vfsMappings}
    '';

  passthru = {
    frontend = callPackage ./frontend.nix { inherit meta version src; };
    tests = { inherit (nixosTests) listmonk; };
  };

  meta = {
    description = "High performance, self-hosted, newsletter and mailing list manager with a modern dashboard";
    mainProgram = "listmonk";
    homepage = "https://github.com/knadh/listmonk";
    changelog = "https://github.com/knadh/listmonk/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ raitobezarius ];
    license = lib.licenses.agpl3Only;
  };
}
