{ stdenv
, buildGoPackage
, fetchFromGitHub
, makeWrapper
}:

buildGoPackage rec {
  pname = "docker-slim";
  version = "1.32.0";

  goPackagePath = "github.com/docker-slim/docker-slim";

  src = fetchFromGitHub {
    owner = "docker-slim";
    repo = "docker-slim";
    rev = version;
    sha256 = "0pd2v7df176ca923c4nw9ns5gz442jkb0jhzqjl53rwfwz1vxy9h";
  };

  subPackages = [ "cmd/docker-slim" "cmd/docker-slim-sensor" ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildFlagsArray = [
    ''-ldflags=
        -s -w -X ${goPackagePath}/pkg/version.appVersionTag=${version}
              -X ${goPackagePath}/pkg/version.appVersionRev=${src.rev}
    ''
  ];

  # docker-slim tries to create its state dir next to the binary (inside the nix
  # store), so we set it to use the working directory at the time of invocation
  postInstall = ''
    wrapProgram "$out/bin/docker-slim" --add-flags '--state-path "$(pwd)"'
  '';

  meta = with stdenv.lib; {
    description = "Minify and secure Docker containers";
    homepage = "https://dockersl.im/";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 marsam mbrgm ];
  };
}
