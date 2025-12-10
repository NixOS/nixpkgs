{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "newt";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "newt";
    tag = version;
    hash = "sha256-dDPpEZ1Z2b24xlR5NwIizvGVRoefVlLjyxz7lmCdiSM=";
  };

  vendorHash = "sha256-iLUeQ16KLRPdAZT3DCe4eGjlqPrNJJ27BNLtTpeQlC0=";

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
