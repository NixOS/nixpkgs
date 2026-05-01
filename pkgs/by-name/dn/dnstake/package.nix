{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dnstake";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "pwnesia";
    repo = "dnstake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k6j7DIwK8YAKmEjn8JJO7XBcap9ui6cgUSJG7CeHAAM=";
  };

  vendorHash = "sha256-l3IKvcO10C+PVDX962tFWny7eMNC48ATIVqiHjpVH/Y=";

  meta = {
    description = "Tool to check missing hosted DNS zones";
    homepage = "https://github.com/pwnesia/dnstake";
    changelog = "https://github.com/pwnesia/dnstake/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dnstake";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
