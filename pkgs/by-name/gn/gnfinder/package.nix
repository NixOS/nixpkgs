{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "gnfinder";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "gnames";
    repo = "gnfinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-huv9NnFQAZwzjZ7EYF0XNDXWBHA3F9yOjLRqxEvLzd0=";
  };

  vendorHash = "sha256-28+KOS5qeSvhkC5QgzwzOKyqqFlbtnUHTsBgZj8vBa0=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gnames/gnfinder/ent/version.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Find and verify scientific names in text";
    homepage = "https://github.com/gnames/gnfinder";
    changelog = "https://github.com/gnames/gnfinder/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "gnfinder";
    maintainers = with lib.maintainers; [ attila ];
  };
})
