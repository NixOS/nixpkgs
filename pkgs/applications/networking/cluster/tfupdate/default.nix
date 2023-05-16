{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tfupdate";
<<<<<<< HEAD
  version = "0.7.2";
=======
  version = "0.6.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "tfupdate";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ii37Au/2jjGdQjc2LnBPkyNNBMbD5XPPo7i3krF33W0=";
  };

  vendorHash = "sha256-gtAenM1URr2wFfe2/zCIyNvG7echjIxSxG1hX2vq16g=";
=======
    sha256 = "sha256-zDrmzubk5ScqZapp58U8NsyKl9yZ48VtWafamDdlWK0=";
  };

  vendorHash = "sha256-nhAeN/UXLR0QBb7PT9hdtNSz1whfXxt6SYejpLJbDbk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Update version constraints in your Terraform configurations";
    homepage = "https://github.com/minamijoyo/tfupdate";
    changelog = "https://github.com/minamijoyo/tfupdate/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ Intuinewin qjoly ];
=======
    maintainers = with maintainers; [ Intuinewin ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
