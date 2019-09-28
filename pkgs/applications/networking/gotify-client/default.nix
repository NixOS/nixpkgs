{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  version = "2.1.1";
  pname = "gotify-client";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "cli";
    rev = "v${version}";
    sha256 = "131gs6xzfggnrzq5jgyky23zvcmhx3q3hd17xvqxd02s2i9x1mg4";
  };

  modSha256 = "1lrsg33zd7m24za2gv407hz02n3lmz9qljfk82whlj44hx7kim1z";

  # Based on upstream's makefile
  buildPhase = ''
    go build -ldflags="-X main.Version=${version}" cli.go
  '';
  installPhase = ''
    mkdir -p ${placeholder "out"}/bin/
    cp cli ${placeholder "out"}/bin/gotify-cli
  '';

  meta = with stdenv.lib; {
    description = "A command line interface for pushing messages to gotify/server";
    homepage = "https://github.com/gotify/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}


