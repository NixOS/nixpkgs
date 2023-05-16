{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nova";
<<<<<<< HEAD
  version = "3.7.0";
=======
  version = "3.6.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = pname;
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-K4D8vCZxOPRalSDlAmva7Qm72EJ2Xdz20oqKKqkD6iA=";
  };

  vendorHash = "sha256-c30B8Wjvwp4NnB1P8h4/raGiGAX/cbTZ/KQqh/qeNhA=";
=======
    rev = version;
    hash = "sha256-bu0iIhoRRi2dzBGGjWy9YJVSHtdO3T1NkLpGMseyK/E=";
  };

  vendorHash = "sha256-YvYfSb2ZC86S2osFRG7Ep9nrgYJV0tB8fBgZQZ07t2U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-X main.version=${version}" "-s" "-w" ];

  meta = with lib; {
    description = "Find outdated or deprecated Helm charts running in your cluster";
    longDescription = ''
      Nova scans your cluster for installed Helm charts, then
      cross-checks them against all known Helm repositories. If it
      finds an updated version of the chart you're using, or notices
      your current version is deprecated, it will let you know.
    '';
    homepage = "https://nova.docs.fairwinds.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
