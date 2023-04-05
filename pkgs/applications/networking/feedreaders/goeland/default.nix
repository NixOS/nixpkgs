{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goeland";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "slurdge";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MD8wdXOZ8Kmun8AYv/zlRKwgAcGu2A349Xr8d7SVX4s=";
  };

  vendorHash = "sha256-BErLmtzgVqDKLFAnKugDBwj3Vgm8rM6BfWcMOhu4SWY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/slurdge/goeland/version.GitCommit=${version}"
  ];

  meta = with lib; {
    description = "An alternative to rss2email written in golang with many filters";
    longDescription = ''
      Goeland excels at creating beautiful emails from RSS feeds,
      tailored for daily or weekly digest. It includes a number of
      filters that can transform the RSS content along the way.
      It can also consume other sources, such as Imgur tags.
    '';
    homepage = "https://github.com/slurdge/goeland";
    changelog = "https://github.com/slurdge/goeland/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.sweenu ];
  };
}
