{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubelogin";
<<<<<<< HEAD
  version = "1.28.0";
=======
  version = "1.27.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "int128";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-8atEUJLXSbLHdxo1wKtAHAFrZkQYWdW6tP2oKoxahXA=";
=======
    sha256 = "sha256-oBgth4lAQP4UrFIk/AErlfyyCgPrugs5wQJDFxqGum0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = ["."];

<<<<<<< HEAD
  vendorHash = "sha256-rLpXBFNBJG3H0+2inCG4wN0I2LuKUhuqozeafUD3aMI=";
=======
  vendorHash = "sha256-IJCbh1ryyk0r72SrVEiI7K5nIFf1+UGjTkXaNKpGsmo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Rename the binary instead of symlinking to avoid conflict with the
  # Azure version of kubelogin
  postInstall = ''
    mv $out/bin/kubelogin $out/bin/kubectl-oidc_login
  '';

  meta = with lib; {
    description = "A Kubernetes credential plugin implementing OpenID Connect (OIDC) authentication";
    inherit (src.meta) homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
