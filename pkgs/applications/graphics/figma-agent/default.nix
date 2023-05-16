{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, fontconfig
, freetype
<<<<<<< HEAD
=======
, libclang
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:
let
  inherit (rustPlatform) buildRustPackage bindgenHook;

<<<<<<< HEAD
  version = "0.2.8";
=======
  version = "0.2.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
buildRustPackage {
  pname = "figma-agent";
  inherit version;

  src = fetchFromGitHub {
    owner = "neetly";
    repo = "figma-agent-linux";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-GtbONBAXoJ3AdpsWGk4zBCtGQr446siMtuj3or27wYw=";
  };

  cargoHash = "sha256-EmBeRdnA59PdzSEX2x+sVYk/Cs7K3k0idDjbuEzI9j4=";

  nativeBuildInputs = [
    pkg-config
    bindgenHook
  ];
=======
    sha256 = "sha256-Cq1hWNwJLBY9Bb41WFJxnr9fcygFZ8eNsn5cPXmGTyw=";
  };

  cargoSha256 = "sha256-Gc94Uk/Ikxjnb541flQL7AeblgU/yS6zQ/187ZGRYco=";

  nativeBuildInputs = [ pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    fontconfig
    freetype
<<<<<<< HEAD
  ];

=======
    bindgenHook
  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/neetly/figma-agent-linux";
    description = "Figma Agent for Linux (a.k.a. Font Helper)";
    license = licenses.mit;
    maintainers = with maintainers; [ ercao ];
  };
}
