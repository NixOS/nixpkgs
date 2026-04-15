{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "gokey";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "gokey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G8cZ5x2XiXdwR0qNCR3KZVGQvu/tOw4vQV26XOZXmKs=";
  };

  vendorHash = "sha256-ntDQi2+7TGVdfgyOhKgaNCfCBK1o5sRC9gVVxonNU6c=";

  meta = {
    homepage = "https://github.com/cloudflare/gokey";
    description = "Vault-less password store";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.confus ];
    mainProgram = "gokey";
  };
})
