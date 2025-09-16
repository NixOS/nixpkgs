{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "newt";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "newt";
    tag = version;
    hash = "sha256-wY9zaBDDNqXAAHlFYADS16yp9TOLIIFkjevQL3K0ySE=";
  };

  vendorHash = "sha256-XYj2hMsK7Gfrk25bRz/ooDkrXmuUdBQSF/ojF7OTQ4I=";

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail "version_replaceme" "${version}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-version" ];

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/newt";
    changelog = "https://github.com/fosrl/newt/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      fab
      jackr
      sigmasquadron
    ];
    mainProgram = "newt";
  };
}
