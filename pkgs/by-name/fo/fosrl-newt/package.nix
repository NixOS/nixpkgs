{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "newt";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "newt";
    tag = version;
    hash = "sha256-yfQ9w1PKLhdpakZQLnQEcOAxpA4LC4S2OFX4dYKgDKw=";
  };

  vendorHash = "sha256-PENsCO2yFxLVZNPgx2OP+gWVNfjJAfXkwWS7tzlm490=";

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
