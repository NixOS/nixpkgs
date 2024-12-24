{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "agebox";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "slok";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QH0kkquLnB00oKuwb5j2ZoAKPnZkSHJRGaq3RXO5ggg=";
  };

  vendorHash = "sha256-s3LZgQpUF0t9ETNloJux4gXXSn5Kg+pcuhJSMfWWnSo=";

  ldflags = [
    "-s"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/slok/agebox";
    changelog = "https://github.com/slok/agebox/releases/tag/v${version}";
    description = "Age based repository file encryption gitops tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
    mainProgram = "agebox";
  };
}
