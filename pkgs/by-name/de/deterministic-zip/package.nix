{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "deterministic-zip";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "timo-reymann";
    repo = "deterministic-zip";
    tag = finalAttrs.version;
    hash = "sha256-yuwy3t2iWBXBwsj0Psy4/1YJ/V/vuNiBVzYzGQXUnkA=";
  };

  vendorHash = "sha256-hEPZrS2D6YqlaaJXF8uyt+fJ38Adi3WvOq7v9dZuovI=";

  ldflags = [
    "-s"
    "-X github.com/timo-reymann/deterministic-zip/pkg/buildinfo.GitSha=${finalAttrs.src.rev}"
    "-X github.com/timo-reymann/deterministic-zip/pkg/buildinfo.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Simple (almost drop-in) replacement for zip that produces deterministic files";
    mainProgram = "deterministic-zip";
    homepage = "https://github.com/timo-reymann/deterministic-zip";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ rhysmdnz ];
  };
})
