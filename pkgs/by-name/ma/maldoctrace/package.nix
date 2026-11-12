{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "maldoctrace";
  version = "0.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "debugactiveprocess";
    repo = "MaldocTrace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p9MUKDCXFXBjpSieS/gHJtwqexclg0pHmxQQd06Glxg=";
  };

  vendorHash = "sha256-+IlBImZXl993J/TEPXF2vasZ2qnroPI7kPA+1pHJpcc=";

  subPackages = [ "cmd/maldoctrace" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/debugactiveprocess/MaldocTrace.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    description = "Analyzer for malicious Office documents that emulates VBA and Excel 4.0 macros";
    homepage = "https://github.com/debugactiveprocess/MaldocTrace";
    changelog = "https://github.com/debugactiveprocess/MaldocTrace/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ debugactiveprocess ];
    mainProgram = "maldoctrace";
  };
})
