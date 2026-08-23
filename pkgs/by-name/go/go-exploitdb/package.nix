{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-exploitdb";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "vulsio";
    repo = "go-exploitdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xL31IvWzIaYAaHw6h8bkuLOMSWC4ogszLfHSNmYvnX0=";
  };

  vendorHash = "sha256-n6vUjcU8RxNOPzZaIOXy0CZZzJjwoWxdFlE9I0TNQ6s=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/vulsio/go-exploitdb/config.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Tool for searching Exploits from Exploit Databases, etc";
    mainProgram = "go-exploitdb";
    homepage = "https://github.com/vulsio/go-exploitdb";
    changelog = "https://github.com/vulsio/go-exploitdb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
