{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goeland";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "slurdge";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-R3ZkGTq0g90DkflLXr2MUBIv5Qspi3OM+sdDGqJYjyw=";
  };

  vendorSha256 = "sha256-iljGBe8c6dqEHRpMN5cz7wmminejoiXXDKuQDazDztA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/slurdge/goeland/version.GitCommit=${version}"
  ];

  meta = with lib; {
    description = "An alternative to RSS2Email written in golang with many filters.";
    longDescription = ''
      Goeland excels at creating beautiful emails from RSS,
      tailored for daily or weekly digest. It include a number of
      filters that can transform the RSS content along the way.
      It can also consume other sources, such as a Imgur tag.
    '';
    homepage = "https://github.com/slurdge/goeland";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.sweenu ];
  };
}
