{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  writableTmpDirAsHomeHook,
  git,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitst";
  version = "0.1.16";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dfallman";
    repo = "gitst";
    tag = finalAttrs.version;
    hash = "sha256-UaDbD6wD1iZDcq5MW2E8TfFcAsssliETv7d1qPCB25k=";
  };

  cargoHash = "sha256-5Q+mSwTwlw8thVVwNGCKIpS/j3eA33/MY2sJyl7TbOI=";

  nativeBuildInputs = [
    makeWrapper
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    git
  ];

  postInstall = ''
    wrapProgram $out/bin/gitst \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time, glanceable interactive git status for the terminal";
    homepage = "https://github.com/dfallman/gitst";
    changelog = "https://github.com/dfallman/gitst/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "gitst";
  };
})
