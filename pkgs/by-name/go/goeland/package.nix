{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goeland";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "slurdge";
    repo = "goeland";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-7npQ04o2GvbOJt1zS7W+VFs38OnNG8VS7Qs7jM79yBg=";
  };

  vendorHash = "sha256-OLgE9PU1/swoHZZG82zAEB1XygZjpK0wrqoGG/4Akvw=";

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
