{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "noti";
  version = "3.9.0";

  src = fetchFromCodeberg {
    owner = "roble";
    repo = "noti";
    tag = finalAttrs.version;
    hash = "sha256-gC4vahFfphw2rogd98b5HdCSbB/QdCvC9JcEqhOVFUs=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/noti" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/variadico/noti/internal/command.Version=${finalAttrs.version}"
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  postInstall = ''
    installManPage docs/man/dist/*
  '';

  meta = {
    description = "Monitor a process and trigger a notification";
    longDescription = ''
      Monitor a process and trigger a notification.

      Never sit and wait for some long-running process to finish. Noti can alert
      you when it's done. You can receive messages on your computer or phone.
    '';
    homepage = "https://codeberg.org/roble/noti";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stites ];
    mainProgram = "noti";
  };
})
