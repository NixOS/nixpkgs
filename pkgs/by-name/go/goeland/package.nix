{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goeland";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "slurdge";
    repo = "goeland";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5pUj7KgjvcA7xuKV7j9nLEih4ecrQjarddRVNszidfE=";
  };

  vendorHash = "sha256-GOoeyh0ddtYiigavgjMNy8z6suTFtS9oswO9PAdagGE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/slurdge/goeland/version.GitCommit=${finalAttrs.version}"
  ];

  meta = {
    description = "Alternative to rss2email written in golang with many filters";
    mainProgram = "goeland";
    longDescription = ''
      Goeland excels at creating beautiful emails from RSS feeds,
      tailored for daily or weekly digest. It includes a number of
      filters that can transform the RSS content along the way.
      It can also consume other sources, such as Imgur tags.
    '';
    homepage = "https://github.com/slurdge/goeland";
    changelog = "https://github.com/slurdge/goeland/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.sweenu ];
  };
})
