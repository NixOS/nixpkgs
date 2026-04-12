{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nomore403";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "devploit";
    repo = "nomore403";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Or5a4905TGvBn4mcVaYNXoHkciEegY4+VbAhkIxAoM8=";
  };

  vendorHash = "sha256-zAkS0o+wOQLmCil7Lh7DIZCcHYiceb1KwiK/vkSYYwk=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.BuildDate=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "Tool to bypass 403/40X response codes";
    homepage = "https://github.com/devploit/nomore403";
    changelog = "https://github.com/devploit/nomore403/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nomore403";
  };
})
