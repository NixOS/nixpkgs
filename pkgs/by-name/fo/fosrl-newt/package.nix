{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "newt";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "newt";
    tag = version;
    hash = "sha256-CtE4Ug1659Xu90CRMIxXeqfVaw9kOK4WpsW/u3S0ztA=";
  };

  vendorHash = "sha256-VR5YOprMP3wvwb0lnW9KyUWGs/4Zm5GKBe4vnkN32cY=";

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
