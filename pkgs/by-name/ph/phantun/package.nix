{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phantun";
  version = "0.8.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dndx";
    repo = "phantun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Syz2W0IYm9nzu2Ph09uJxeo/odznDC9aMe+TEMhWurc=";
  };

  cargoHash = "sha256-xvWk1OmF/oWc2Pw3rxkkRNZ63XSkSf41klzQz1+2O9I=";

  postInstall = ''
    mv "$out/bin/client" "$out/bin/phantun_client"
    mv "$out/bin/server" "$out/bin/phantun_server"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  postVersionCheck = ''
    "$out/bin/phantun_server" --version | grep -F "${finalAttrs.version}"
  '';

  meta = {
    description = "Lightweight and fast UDP to TCP obfuscator";
    homepage = "https://github.com/dndx/phantun";
    changelog = "https://github.com/dndx/phantun/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ peigongdsd ];
    mainProgram = "phantun_client";
    platforms = lib.platforms.linux;
  };
})
