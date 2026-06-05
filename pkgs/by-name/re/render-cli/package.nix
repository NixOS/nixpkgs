{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "render-cli";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "render-oss";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-S3XWxK40jIX5l1o4km5CJLcPqEp10hjKYb+iWZSNKck=";
  };

  vendorHash = "sha256-0cOW8g9rhUbcBF/JfsYu8OJJhaDXAd37341GZeoCAVQ=";

  # Tests require network access
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/render-oss/cli/pkg/cfg.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/render
  '';

  meta = {
    description = "Official command-line interface for Render cloud hosting platform";
    homepage = "https://github.com/render-oss/cli";
    changelog = "https://github.com/render-oss/cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jtamagnan ];
    mainProgram = "render";
  };
}
