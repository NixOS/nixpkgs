{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "beancount-language-server";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    tag = finalAttrs.version;
    hash = "sha256-HQXLPXs/huoFSM0tqs8FN/hggJauMwef7SbLb2tZoZc=";
  };

  cargoHash = "sha256-Zdz+zn8oZnLAarQySVpuBK+Mwf21Bm7Ug9ECNwlAZYs=";

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/beancount-language-server --help > /dev/null
  '';

  meta = {
    description = "Language Server Protocol (LSP) for beancount files";
    mainProgram = "beancount-language-server";
    homepage = "https://github.com/polarmutex/beancount-language-server";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ polarmutex ];
  };
})
