{ lib
, stdenv
, fetchFromGitHub
, electron
, runtimeShell
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "nix-tour";
  version = "unstable-2022-01-03";

  src = fetchFromGitHub {
    owner = "nixcloud";
    repo = "tour_of_nix";
    rev = "6a6784983e6dc121574b97eb9b1d03592c8cb9a7";
    sha256 = "sha256-BhQz59wkwwY0ShXzqUD6MQl4NE/jUik5RbLzseEc5Bc=";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];
  buildInputs = [ electron ];

  installPhase = ''
    install -d $out/bin $out/share/nix-tour
    cp -R * $out/share/nix-tour
    makeWrapper ${electron}/bin/electron $out/bin/nix-tour \
      --add-flags $out/share/nix-tour/electron-main.js
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Tour of Nix";
      genericName = "Tour of Nix";
      comment =
        "Interactive programming guide dedicated to the nix programming language";
      categories = [ "Development" "Documentation" ];
      exec = "nix-tour";
    })
  ];

  meta = with lib; {
    description = "'the tour of nix' from nixcloud.io/tour as offline version";
    homepage = "https://nixcloud.io/tour";
    license = licenses.gpl2;
    maintainers = with maintainers; [ qknight yuu ];
  };
}
