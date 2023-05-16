{ lib
, cni-plugins
, buildGoModule
, firecracker
, containerd
, runc
, makeWrapper
, fetchFromGitHub
}:

buildGoModule rec{
  pname = "flintlock";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flintlock";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-jZi58mewQ2hlH/9H4iAF4Mvf9UK4F7sUR0xcCEaLzX0=";
  };

  vendorHash = "sha256-IGfNMe1fQfAGAOVsxmn/oxleHfniqL1TJKllCwpuWOU=";
=======
    sha256 = "sha256-kHrVpQ4E8b1YV+ofZwd4iGJ9ucVUUam6rxdpOGmvRR4=";
  };

  vendorSha256 = "sha256-A3LrikB2KrnSI+OREiLmlkTFpRKQWRB8w4OJ6ApX7oY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/flintlock-metrics" "cmd/flintlockd" ];

  ldflags = [ "-s" "-w" "-X github.com/weaveworks/flintlock/internal/version.Version=v${version}" ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    firecracker
  ];

  postInstall = ''
    for prog in flintlockd flintlock-metrics; do
      wrapProgram "$out/bin/$prog" --prefix PATH : ${lib.makeBinPath [ cni-plugins firecracker containerd runc ]}
    done
  '';

  meta = with lib; {
    description = "Create and manage the lifecycle of MicroVMs backed by containerd";
    homepage = "https://github.com/weaveworks-liquidmetal/flintlock";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ techknowlogick ];
  };
}
