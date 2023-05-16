{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, AppKit
, libxcb
}:

rustPlatform.buildRustPackage rec {
  pname = "cotp";
<<<<<<< HEAD
  version = "1.2.5";
=======
  version = "1.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-c2QjFDJmRLlXU1ZMOjb0BhIRgqubCTRyncc2KUKOhsg=";
  };

  cargoHash = "sha256-NnxgNk/C1DmEmPb2AcocsPsp2ngdyjbMP71M+fNL1qA=";
=======
    hash = "sha256-Pg07iq2jj8cUA4iQsY52cujmUZLYrbTG5Zj+lITxpls=";
  };

  cargoHash = "sha256-9jOrDFLnzjxqN2h6e1/qKRn5RQKlfyeKKmjZthQX3jM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ davsanchez ];
  };
}
