{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goeland";
  version = "0.29.2";

  src = fetchFromGitHub {
    owner = "slurdge";
    repo = "goeland";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-U9n7qCUlft27GzGGBDmKmajWVl3v+v9WQmOB1/84KtQ=";
  };

  vendorHash = "sha256-lBHX6reFEEbKcnf+TzuT5l7SsyVWoCA6HbkkL9UPwrg=";

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
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sweenu ];
  };
})
