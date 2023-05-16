{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-images";
<<<<<<< HEAD
  version = "0.6.3";
=======
  version = "0.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "chenjiandongx";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-FHfj2qRypqQA0Vj9Hq7wuYd0xmpD+IZj3MkwKljQio0=";
  };

  vendorHash = "sha256-8zV2iZ10H5X6fkRqElfc7lOf3FhmDzR2lb3Jgyhjyio=";
=======
    sha256 = "sha256-aDWtLTnMQklTU6X6LF0oBuh1317I5/kiEZVePgJjIdU";
  };

  vendorSha256 = "sha256-FxaOOFwDf3LNREOlA7frqhDXzc91LC3uJev3kzLDEy8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubectl-images
  '';

  meta = with lib; {
    description = "Show container images used in the cluster.";
    homepage = "https://github.com/chenjiandongx/kubectl-images";
    changelog = "https://github.com/chenjiandongx/kubectl-images/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
