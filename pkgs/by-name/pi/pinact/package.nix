{ lib
, fetchFromGitHub
, buildGoModule
, versionCheckHook
}:

let
  pname = "pinact";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "pinact";
    rev = "v${version}";
    hash = "sha256-HfeHfKXDBHPgxisWSVnrLOQf/4NXtnehkIjQqiCoFIc=";
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-L9EGygiJ40f7Yw46KdaAof5O/ren6inTK7XerB/uv1g=";

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version} -X main.commit=${src.rev}"
  ];

  meta = with lib; {
    description = "Pin GitHub Actions versions";
    homepage = "https://github.com/suzuki-shunsuke/pinact";
    changelog = "https://github.com/suzuki-shunsuke/pinact/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ maintainers.kachick ];
    mainProgram = "pinact";
  };
}
