{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "goshs";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "patrickhener";
    repo = "goshs";
    tag = "v${version}";
    hash = "sha256-xq9BqWhUZfk4p5C6d5Eqh98bs0ZDTjpy5KnvhV/9Jew=";
  };

  vendorHash = "sha256-ECh0K3G6VAAJihqzzlWaEQclfXa0Wp/eFL16ABa7r+0=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  meta = {
    description = "HTTP Server";
    homepage = "https://github.com/patrickhener/goshs";
    changelog = "https://github.com/patrickhener/goshs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "goshs";
  };
}
