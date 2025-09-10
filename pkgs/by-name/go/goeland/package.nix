{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goeland";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "slurdge";
    repo = "goeland";
    rev = "v${version}";
    sha256 = "sha256-5MKkjUOAXz6R7PdChuJA4ybc07gHdO9BF68CpI7OExA=";
  };

  vendorHash = "sha256-Jnui1toAV4VvPs6T7UqgAUarFjuik/OnLUrF5VqI+EU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/slurdge/goeland/version.GitCommit=${version}"
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
    changelog = "https://github.com/slurdge/goeland/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.sweenu ];
  };
}
