{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "senv";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "SpectralOps";
    repo = "senv";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-TjlIX8FPNiPDQo41pIt04cki/orc+v30pV3o2bQQhAQ=";
  };

  vendorHash = "sha256-zOWX0AiLAs1FtOn+VtRexfn6oOmJT1PoTPHkcpwvxRY=";

  subPackages = [ "." ];

  meta = {
    description = "Friends don't let friends leak secrets on their terminal window";
    homepage = "https://github.com/SpectralOps/senv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    broken = stdenv.hostPlatform.isDarwin; # needs golang.org/x/sys bump
    mainProgram = "senv";
  };
})
