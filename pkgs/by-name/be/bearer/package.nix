{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bearer";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BhO7/63AdyJnZBjalWpCpgaXqUfSsqv20Im1zbzFJL0=";
  };

  vendorHash = "sha256-MZnUlrVYg9vfMfrwNkR6CJra6aEVGdNXDbzfYr8YAFw=";

  subPackages = [ "cmd/bearer" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
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
