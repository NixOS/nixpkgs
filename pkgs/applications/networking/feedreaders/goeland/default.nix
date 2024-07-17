{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goeland";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "slurdge";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4xhw6L6CuwW2MepwGvpVLVafMcU/g0bn/2M/8ZSRF/U=";
  };

  vendorHash = "sha256-TZIHYFE4kJu5EOQ9oT8S0Tp/r38d5RhoLdmIrus8Ibc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/slurdge/goeland/version.GitCommit=${version}"
  ];

  meta = with lib; {
    description = "An alternative to rss2email written in golang with many filters";
    mainProgram = "goeland";
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
