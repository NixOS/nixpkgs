{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "go-org";
<<<<<<< HEAD
  version = "1.7.0";
=======
  version = "1.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "niklasfasching";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BPCQxl0aJ9PrEC5o5dc5uBbX8eYAxqB+qMLXo1LwCoA=";
  };

  vendorHash = "sha256-HbNYHO+tqFEs9VXdxyA+r/7mM/p+NBn8PomT8JAyKR8=";
=======
    sha256 = "sha256-Wp8WEfRcrtn+VdcbehYcOJI5FkPQiyo6nLsTDvR7riE=";
  };

  vendorSha256 = "sha256-njx89Ims7GZql8sbVmH/E9gM/ONRWiPRLVs+FzsCSzI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstallCheck = ''
    $out/bin/go-org > /dev/null
  '';

  meta = with lib; {
    description = "Org-mode parser and static site generator in go";
    homepage = "https://niklasfasching.github.io/go-org";
    license = licenses.mit;
    maintainers = with maintainers; [ payas ];
  };
}
