{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "corso";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "alcionai";
    repo = "corso";
    rev = "v${version}";
    hash = "sha256-zNl2S3KzEOYPdOxNkyhxPSjEgOOo3paybX2wXs7wX5s=";
  };

  sourceRoot = "${src.name}/src";
  subPackages = [ "." ];

  vendorHash = "sha256-1JZ8TYlVttQzGW6vxYEokFZj8P9mUnik1Agmm19w+LI=";

  ldflags = [ "-s" "-w" "-X 'github.com/alcionai/corso/src/internal/version.Version=${version}'" ];

  postInstall = ''
    mv $out/bin/{src,${pname}}
  '';

  meta = with lib; {
    description = "Free, Secure, and Open-Source Backup for Microsoft 365";
    homepage = "https://github.com/alcionai/corso";
    changelog = "https://github.com/alcionai/corso/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ meain ];
  };
}
