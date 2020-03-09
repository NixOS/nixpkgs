{ stdenv
, buildGoPackage
, fetchFromGitHub
, makeWrapper
}:

buildGoPackage rec {
  pname = "docker-slim";
  version = "1.28.0";

  goPackagePath = "github.com/docker-slim/docker-slim";

  src = fetchFromGitHub {
    owner = "docker-slim";
    repo = "docker-slim";
    rev = version;
    sha256 = "1yqg7ngrgq1382clyaal40v7rg9p54hyf78mdrzql454yzxfa819";
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
    wrapProgram "$bin/bin/docker-slim" --add-flags '--state-path "$(pwd)"'
  '';

  meta = with stdenv.lib; {
    description = "Minify and secure Docker containers";
    homepage = "https://dockersl.im/";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 marsam mbrgm ];
    # internal/app/sensor/monitors/ptrace/monitor.go:151:16: undefined:
    #     system.CallNumber
    # internal/app/sensor/monitors/ptrace/monitor.go:161:15: undefined:
    #     system.CallReturnValue
    badPlatforms = [ "aarch64-linux" ];
  };
}
