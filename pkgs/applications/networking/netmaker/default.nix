{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, libglvnd
, pkg-config
, subPackages ? ["." "netclient"]
, xorg
}:

buildGoModule rec {
  pname = "netmaker";
<<<<<<< HEAD
  version = "0.21.0";
=======
  version = "0.19.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-RL0tGhtndahTezQFz/twyLh36h2RXFy7EUnPiLAxP4U=";
  };

  vendorHash = "sha256-4Wxutkg9OdKs6B8z/P6JMgcE3cGS+6W4V7sKzVBwRJc=";
=======
    hash = "sha256-wiexultPliYD3WrLVtWUdLs762OzLAmoH66phwjOuUw=";
  };

  vendorHash = "sha256-Msvonap1soJExzBymouY8kZJnHT4SIwpfJjBgpkO2Rw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  inherit subPackages;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libglvnd
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
  ];

  meta = with lib; {
    description = "WireGuard automation from homelab to enterprise";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netmaker/-/releases/v${version}";
    license = licenses.sspl;
<<<<<<< HEAD
    maintainers = with maintainers; [ urandom qjoly ];
=======
    maintainers = with maintainers; [ urandom ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
