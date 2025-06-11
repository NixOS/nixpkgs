{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dnstake";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "pwnesia";
    repo = "dnstake";
    tag = "v${version}";
    hash = "sha256-k6j7DIwK8YAKmEjn8JJO7XBcap9ui6cgUSJG7CeHAAM=";
  };

  vendorHash = "sha256-lV6dUl+OMUQfhlgNL38k0Re1Mr3VP9b8SI3vTJ8CP18=";

  meta = with lib; {
    description = "Tool to check missing hosted DNS zones";
    homepage = "https://github.com/pwnesia/dnstake";
    changelog = "https://github.com/pwnesia/dnstake/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "dnstake";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
