{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "irtt";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "heistp";
    repo = "irtt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-22ibxq78pt9pHq58jowMo0nENFy39ZSl/oBw9/F7vAc=";
  };

  vendorHash = "sha256-du6PXKBrb3qrvD6rBFWfY3pK2gVu7/nvvom5mHs+JJs=";
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Measures round-trip time, one-way delay and other metrics using UDP";
    homepage = "https://github.com/heistp/irtt";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.tsheinen ];
    mainProgram = "irtt";
    platforms = lib.platforms.linux;
  };
})
