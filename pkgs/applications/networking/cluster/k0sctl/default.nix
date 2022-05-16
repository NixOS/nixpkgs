{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, installShellFiles
}:

buildGoModule rec {
  pname = "k0sctl";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TkkMO6xBHY5t5Rpd0ieSDXMrnQ+Xdq+65Rk93ZkYcUs=";
  };

  vendorSha256 = "sha256-nTAuvHcsJiW0XYX5GM1SL8cnOhwdrj6iw8tuAkEWNzQ=";

  patches = [
    (fetchpatch {
      url = "https://github.com/k0sproject/${pname}/commit/22c694ab0335a1e6146d0d3f939ef79d2c005a3d.patch";
      sha256 = "sha256-Ftq/vbQd5ArdHboDt6NdyuqpFalHVnsQBdpmyDG/t5Q=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k0sproject/k0sctl/version.Environment=production"
    "-X github.com/k0sproject/k0sctl/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd ${pname} \
        --$shell <($out/bin/${pname} completion --shell $shell)
    done
  '';

  meta = with lib; {
    description = "A bootstrapping and management tool for k0s clusters.";
    homepage = "https://k0sproject.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
