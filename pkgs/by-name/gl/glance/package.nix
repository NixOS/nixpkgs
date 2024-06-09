{ lib,
buildGoModule,
fetchFromGitHub,
nix-update-script
}:

buildGoModule rec {
  pname = "glance";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "glanceapp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-37DmLZ8ESJwB2R8o5WjeypKsCQwarF3x8UYz1OQT/tM=";
  };

  vendorHash = "sha256-Okme73vLc3Pe9+rNlmG8Bj1msKaVb5PaIBsAAeTer6s=";

  excludedPackages = [ "scripts/build-and-ship" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/glanceapp/glance";
    changelog = "https://github.com/glanceapp/glance/releases/tag/v${version}";
    description = "A self-hosted dashboard that puts all your feeds in one place";
    mainProgram = "glance";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ dvn0 ];
  };
}
