{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "svetovit";
  version = "1.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TadeasDitte";
    repo = "svetovit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5JWKt5UG0olcy2JQvBLN8F+xb2zJPAil4oiDjc0ZYEE=";
  };

  vendorHash = "sha256-08YXnImx6AYNyNWxWQ4CsfIMIkCriyfZmf3XgmeBkZ8=";

  subPackages = [ "cmd/svetovit" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vulnerability scanner for CMS installs and system packages, client to a Rozhanitsy server";
    homepage = "https://github.com/TadeasDitte/svetovit";
    changelog = "https://github.com/TadeasDitte/svetovit/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    mainProgram = "svetovit";
    maintainers = with lib.maintainers; [ TadeasDitte ];
  };
})
