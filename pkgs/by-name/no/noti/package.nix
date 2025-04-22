{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "noti";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "variadico";
    repo = "noti";
    tag = version;
    hash = "sha256-FwOS4ifMiODIzKVQufLhkDYOcmXz9dAfWw+hM3rXT/Y=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/variadico/noti/internal/command.Version=${version}"
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
}
