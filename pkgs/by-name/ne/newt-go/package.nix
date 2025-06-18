{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "newt";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "newt";
    tag = version;
    hash = "sha256-EXMAPIxSK3H2w7jHSGAfxL9wWR8kGloh6oO+/Eo7+Vc=";
  };

  vendorHash = "sha256-Yc5IXnShciek/bKkVezkAcaq47zGiZP8vUHFb9p09LI=";

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail "replaceme" "${version}"
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
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "newt";
  };
}
