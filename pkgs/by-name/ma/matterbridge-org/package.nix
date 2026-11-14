{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "matterbridge-org";
  version = "1.26.1-unstable-2026-10-24";

  src = fetchFromGitHub {
    owner = "matterbridge-org";
    repo = "matterbridge";
    rev = "ef72d19f9d88e00032dfa8062d7920a67466491f";
    hash = "sha256-GjXoRgQt0AOeVVazAPT4APqfLmgr6vtmdWEJ+OUL5Ls=";
  };

  vendorHash = "sha256-8p3r3PfqdY2y/FPgmq6SCG1wZhgZ3soCfjKRyvXdGq0=";

  __structuredAttrs = true;

  subPackages = [ "." ];

  tags = [ "goolm" ];

  meta = {
    description = "matterbridge community-maintained fork";
    homepage = "https://github.com/matterbridge-org/matterbridge";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ tobiasBora ];
    mainProgram = "matterbridge";
  };
}
