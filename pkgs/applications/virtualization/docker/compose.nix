{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-compose";
<<<<<<< HEAD
  version = "2.21.0";
=======
  version = "2.17.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JekWw5YI6O+CLXc7oNIxPJsRzYimGFDGL6ACyM4D04k=";
=======
    sha256 = "sha256-9P6WpTefcyKtpPGbe+nxoatG/i8v8C/vOX28j9Cu1Hc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # entirely separate package that breaks the build
    rm -rf e2e/
  '';

<<<<<<< HEAD
  vendorHash = "sha256-vVnaZLvPbhJNFn/ACuYDbXCKPKNlYoGCm+liTlPMcjs=";
=======
  vendorHash = "sha256-YnGO5ccl1W3Q6DQ+6cEw7AEZTSbPcvJdQIWzWbQJ9Yo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-X github.com/docker/compose/v2/internal.Version=${version}" "-s" "-w" ];

  doCheck = false;
  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/cmd $out/libexec/docker/cli-plugins/docker-compose

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-compose $out/bin/docker-compose
    runHook postInstall
  '';

  meta = with lib; {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    homepage = "https://github.com/docker/compose";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ babariviere ];
=======
    maintainers = with maintainers; [ babariviere SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
