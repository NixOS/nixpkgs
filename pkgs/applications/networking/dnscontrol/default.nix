{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnscontrol";
<<<<<<< HEAD
  version = "4.3.0";
=======
  version = "3.31.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-poLRt/T7BGzcIBjBcm943XnSurO3DJOx2QyqjDcqNRo=";
  };

  vendorHash = "sha256-3xT5WPBcEclXad8zBA+T7/M6fDmfMWljV8NuxvtvTsA=";
=======
    sha256 = "sha256-BHsvw4X8HWxAACq+4/rR/XHjVVt0qmAxYETDyp1Z/cg=";
  };

  vendorHash = "sha256-N7KS48Kr9SipliZ9JhMo2u9pRoE8+pxhC8B/YcZlNyg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  preCheck = ''
    # requires network
    rm pkg/spflib/flatten_test.go pkg/spflib/parse_test.go
  '';

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
<<<<<<< HEAD
    homepage = "https://dnscontrol.org/";
    changelog = "https://github.com/StackExchange/dnscontrol/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
    mainProgram = "dnscontrol";
=======
    homepage = "https://stackexchange.github.io/dnscontrol/";
    changelog = "https://github.com/StackExchange/dnscontrol/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
