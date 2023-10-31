{ lib
, stdenv
, fetchFromGitHub
, iw
, networkmanager
, wofi
, yad
}:

stdenv.mkDerivation rec {
  pname = "wifi4wofi";
  version = "unstable-2023-08-24";

  src = fetchFromGitHub {
    owner = "fearlessgeekmedia";
    repo = "wifi4wofi";
    rev = "03f809a14fdf10acaeb56b09e3fa2e3bf1fd6200";
    hash = "sha256-a3nLCYZhXcW9dKdPUBp7z98tM7jaCSk1AaebfIde2tg=";
  };

  buildInputs = [ iw networkmanager wofi yad ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/${pname} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "A fork of wofi-wifi-menu. A wifi menu for wofi";
    homepage = "https://github.com/fearlessgeekmedia/wifi4wofi";
    changelog = "https://github.com/fearlessgeekmedia/wifi4wofi/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "wifi4wofi";
    inherit (wofi.meta) platforms;
  };
}
