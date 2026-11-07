{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "certigo";
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "square";
    repo = "certigo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4nGPgtysa3u+lkMmc2H57ShK47y6T3AHEyhXecrrpUk=";
  };

  vendorHash = "sha256-LpLnWB5SIouPhXAX8moijZnU4l/dNnQXXEQXYYxyMa4=";

  meta = {
    description = "Utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    changelog = "https://github.com/square/certigo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "certigo";
  };
})
