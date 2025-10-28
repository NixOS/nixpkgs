{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "pmtiles";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    tag = "v${version}";
    hash = "sha256-JGsbgBB2T+4SWKQmiSmuMqQ8gw0qhM5c5eFDF/+sndA=";
  };

  vendorHash = "sha256-6zsX7rU+D+RUHwXfFZzLQftQ6nSYJhvKIDdsO2vow4A=";

  overrideModAttrs = old: {
    # https://gitlab.com/cznic/libc/-/merge_requests/10
    postBuild = ''
      patch -p0 < ${./darwin-sandbox-fix.patch}
    '';
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=v${version}"
  ];

  postInstall = ''
    mv $out/bin/go-pmtiles $out/bin/pmtiles
  '';

  meta = {
    description = "Single-file utility for creating and working with PMTiles archives";
    homepage = "https://github.com/protomaps/go-pmtiles";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ theaninova ];
    teams = [ lib.teams.geospatial ];
    mainProgram = "pmtiles";
  };
}
