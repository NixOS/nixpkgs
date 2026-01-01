{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "pmtiles";
<<<<<<< HEAD
  version = "1.29.1";
=======
  version = "1.28.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "protomaps";
    repo = "go-pmtiles";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3MWrTqPoEwceOx7zoYOrsKArZKvPXhyaRp5gXVCLOzs=";
  };

  vendorHash = "sha256-UzpyvWsfbzYTngMdWU+fgZj/yQvSfJzhFWpFRsD24GE=";
=======
    hash = "sha256-JGsbgBB2T+4SWKQmiSmuMqQ8gw0qhM5c5eFDF/+sndA=";
  };

  vendorHash = "sha256-6zsX7rU+D+RUHwXfFZzLQftQ6nSYJhvKIDdsO2vow4A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
