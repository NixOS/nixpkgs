{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pkarr";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "pubky";
    repo = "pkarr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KVTFBGLcwE+w2WRYkHhq0oOVDXJwVflXIHS9HWGM9AQ=";
  };

  cargoHash = "sha256-0x9H1iEmFa7fNL4+guqnpPJieyrOkRFrlrU0M7EOqqI=";

  meta = {
    description = "Public Key Addressable Resource Records (sovereign TLDs) ";
    homepage = "https://github.com/pubky/pkarr";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ dpc ];
    mainProgram = "pkarr-server";
  };
})
