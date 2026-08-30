{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ffuf";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "ffuf";
    repo = "ffuf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xN7FxxxIpkaGlfBgs0RwEPlzo/HLMfioC6MAMVP2su8=";
  };

  vendorHash = "sha256-SrC6Q7RKf+gwjJbxSZkWARw+kRtkwVv1UJshc/TkNdc=";

  ldflags = [
    "-s"
    "-X github.com/ffuf/ffuf/v${(lib.versions.major finalAttrs.version)}/pkg/ffuf.VERSION=${finalAttrs.version}"
    "-X github.com/ffuf/ffuf/v${(lib.versions.major finalAttrs.version)}/pkg/ffuf.VERSION_APPENDIX="
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = "-V";

  meta = {
    description = "Tool for web fuzzing";
    longDescription = ''
      FFUF, or "Fuzz Faster you Fool" is an open source web fuzzing tool,
      intended for discovering elements and content within web applications
      or web servers.
    '';
    homepage = "https://github.com/ffuf/ffuf";
    changelog = "https://github.com/ffuf/ffuf/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ffuf";
  };
})
