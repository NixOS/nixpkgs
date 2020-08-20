{ stdenv
, buildGoPackage
, fetchFromGitHub
, makeWrapper
}:

buildGoPackage rec {
  pname = "docker-slim";
  version = "1.31.0";

  goPackagePath = "github.com/docker-slim/docker-slim";

  src = fetchFromGitHub {
    owner = "docker-slim";
    repo = "docker-slim";
    rev = version;
    sha256 = "0kj97kwyjs9hksaas0zic4m7w8b17c1d7c8vhiq2862w97ngxrsk";
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
