{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "konstructio";
    repo = "kubefirst";
    tag = "v${version}";
    hash = "sha256-WggQdhMFbUbJ2bAj2oSveIHMg1HWPj0I14qiE3PTGqE=";
  };

  vendorHash = "sha256-WjucnfiMxthygFaxseggMmlkF/Oih310O56Y7lW+11E=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/konstructio/kubefirst-api/configs.K1Version=v${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Tool to create instant GitOps platforms that integrate some of the best tools in cloud native from scratch";
    mainProgram = "kubefirst";
    homepage = "https://github.com/konstructio/kubefirst/";
    changelog = "https://github.com/konstructio/kubefirst/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
  };
}
