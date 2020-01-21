{ stdenv
, buildGoPackage
, fetchFromGitHub
, makeWrapper
}:

let

  version = "1.26.1";
  rev = "2ec04e169b12a87c5286aa09ef44eac1cea2c7a1";

in buildGoPackage rec {
  pname = "docker-slim";
  inherit version;

  goPackagePath = "github.com/docker-slim/docker-slim";

  src = fetchFromGitHub {
    owner = "docker-slim";
    repo = "docker-slim";
    inherit rev;
    # fetchzip yields a different hash on Darwin because `use-case-hack`
    sha256 =
      if stdenv.isDarwin
      then "0j72rn6qap78qparrnslxm3yv83mzy1yc7ha0crb4frwkzmspyvf"
      else "01bjb14z7yblm7qdqrx1j2pw5x5da7a6np4rkzay931gly739gbh";
  };

  subPackages = [ "cmd/docker-slim" "cmd/docker-slim-sensor" ];

  nativeBuildInputs = [
    makeWrapper
  ];

  # docker-slim vendorized logrus files in different directories, which
  # conflicts on case-sensitive filesystems
  preBuild = stdenv.lib.optionalString stdenv.isLinux ''
    mv go/src/${goPackagePath}/vendor/github.com/Sirupsen/logrus/* \
      go/src/${goPackagePath}/vendor/github.com/sirupsen/logrus/
  '';

  buildFlagsArray =
    let
      ldflags = "-ldflags=-s -w " +
                "-X ${goPackagePath}/pkg/version.appVersionTag=${version} " +
                "-X ${goPackagePath}/pkg/version.appVersionRev=${rev}";
    in
      [ ldflags ];

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
