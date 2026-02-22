{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bearer";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kWs8NiuOroKgQC0Duvef9O7TqQnqgEd28EQZVf4y4oQ=";
  };

  vendorHash = "sha256-uMu5CL/VAlSd2yZzbkr0ceQdUVJvhs9R+IoyZbtZPk8=";

  subPackages = [ "cmd/bearer" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/bearer/bearer/cmd/bearer/build.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Code security scanning tool (SAST) to discover, filter and prioritize security and privacy risks";
    homepage = "https://github.com/bearer/bearer";
    changelog = "https://github.com/Bearer/bearer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "bearer";
  };
})
