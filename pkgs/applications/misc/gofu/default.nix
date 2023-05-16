{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofu";
<<<<<<< HEAD
  version = "unstable-2023-04-25";
=======
  version = "unstable-2022-04-01";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "majewsky";
    repo = pname;
<<<<<<< HEAD
    rev = "f308ca92d1631e579fbfe3b3da13c93709dc18a2";
    hash = "sha256-8c/Z+44gX7diAhXq8sHOqISoGhYdFA7VUYn7eNMCYxY=";
  };

  vendorHash = null;
=======
    rev = "be0e424eecec3fec19ba3518f8fd1bb07b6908dc";
    sha256 = "sha256-jMOmvCsuRtL9EgPicdNEksVgFepL/JZA53o2wzr8uzQ=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  postInstall = ''
    ln -s $out/bin/gofu $out/bin/rtree
    ln -s $out/bin/gofu $out/bin/prettyprompt
  '';

  meta = with lib; {
    description = "Multibinary containing several utilities";
    homepage = "https://github.com/majewsky/gofu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
