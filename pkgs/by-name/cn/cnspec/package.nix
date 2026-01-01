{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnspec";
<<<<<<< HEAD
  version = "12.15.0";
=======
  version = "12.11.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QPTmsJ7hwA6QGRHWrRELrAjSzZbNQVm1O1adxKU08Ak=";
=======
    hash = "sha256-vU6ezKt9pmcHiNHiwNYnJS7ClyEibJ9gK/JUM7/8SMo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  proxyVendor = true;

<<<<<<< HEAD
  vendorHash = "sha256-rIrcnYN/6uyxLi4Wqr3v2Tsv6xPEF1ZfvLqkgDBrj2E=";
=======
  vendorHash = "sha256-UDMJsqDg4cDzj15vw/3JDRT3rVcZ/VuAuv5LYSCPY1k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "apps/cnspec" ];

  ldflags = [
    "-s"
    "-w"
    "-X=go.mondoo.com/cnspec.Version=${version}"
  ];

<<<<<<< HEAD
  meta = {
    description = "Open source, cloud-native security and policy project";
    homepage = "https://github.com/mondoohq/cnspec";
    changelog = "https://github.com/mondoohq/cnspec/releases/tag/v${version}";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Open source, cloud-native security and policy project";
    homepage = "https://github.com/mondoohq/cnspec";
    changelog = "https://github.com/mondoohq/cnspec/releases/tag/v${version}";
    license = licenses.bsl11;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      fab
      mariuskimmina
    ];
  };
}
