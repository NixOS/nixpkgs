{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
  tesseract,
}:

buildNpmPackage (finalAttrs: {
  pname = "liteparse";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "liteparse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hbCD9kXuI3Zh4S69FCXtNQxVFWpP172YwJ95BY/INBw=";
  };

  npmDepsHash = "sha256-KhtwPl1J9ZZMT9xT5bQJjPa3fYTvi9oRnxijCm0o+2c=";
  npmBuildScript = "build";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/lit \
      --set TESSDATA_PREFIX "${tesseract}/share/tessdata"
  '';

  # https://github.com/run-llama/liteparse/blob/270d558441fefdc4a53da258c5ee0cf9d5881286/package-lock.json#L3
  # lock file needs to be updated
  #  nativeInstallCheckInputs = [
  #    versionCheckHook
  #  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and lightweight document parser by LlamaIndex";
    homepage = "https://github.com/run-llama/liteparse";
    changelog = "https://github.com/run-llama/liteparse/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
    platforms = lib.platforms.all;
    mainProgram = "lit";
  };
})
