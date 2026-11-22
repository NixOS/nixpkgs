{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "gotestsum";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TTv1CUBG6rEgnb0NV3ntDAg2ofAL+1WysFMkH0cGrBI=";
  };

  vendorHash = "sha256-25AhWZiXhniZ6Gmw4J7psE/FfbS1j7Ncte0s43Xo98o=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X gotest.tools/gotestsum/cmd.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/gotestyourself/gotestsum";
    changelog = "https://github.com/gotestyourself/gotestsum/releases/tag/v${finalAttrs.version}";
    description = "Human friendly `go test` runner";
    mainProgram = "gotestsum";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
