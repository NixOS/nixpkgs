{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "noti";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "variadico";
    repo = "noti";
    tag = finalAttrs.version;
    hash = "sha256-FwOS4ifMiODIzKVQufLhkDYOcmXz9dAfWw+hM3rXT/Y=";
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
    homepage = "https://github.com/variadico/noti";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stites ];
    mainProgram = "noti";
  };
})
