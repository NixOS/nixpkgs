{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pike-md";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "zachthieme";
    repo = "pike";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YGYmsbpmDBN0rYlUi7Xrpf+bCW0B9criOaFbazPQe94=";
  };

  vendorHash = "sha256-tN+9O4Z1Gtm1AwHTgjM3jJNk4jAhdlb6oOwdaGYpM6o=";

  subPackages = [ "cmd/pike" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/pike $out/bin/pike-md
  '';

  meta = {
    description = "Task extraction tool that scans markdown files for checkboxes and tagged items";
    homepage = "https://github.com/zachthieme/pike";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pike-md";
  };
})
