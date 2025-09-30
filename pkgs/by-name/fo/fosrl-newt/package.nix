{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "newt";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "newt";
    tag = version;
    hash = "sha256-uIlBAqe93MqMSN0Nghlfa1cLbMlcg3iMCzIu0U16h5o=";
  };

  vendorHash = "sha256-FeDNv1mLTvXYUDOHzyPP7uA+fOt/j0VT7CM6IyoMuTQ=";

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
