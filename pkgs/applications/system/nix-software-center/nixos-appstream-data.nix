{ stdenv
, lib
, fetchFromGitHub
, appstream
}:
stdenv.mkDerivation rec {
  pname = "nixos-appstream-data";
  version = "0.0.1";

  buildInputs = [
    appstream
  ];

  src = fetchFromGitHub {
    owner = "vlinkz";
    repo = "nixos-appstream-data";
    rev = "66b3399e6d81017c10265611a151d1109ff1af1b";
    hash = "sha256-oiEZD4sMpb2djxReg99GUo0RHWAehxSyQBbiz8Z4DJk=";
  };

  installPhase = ''
    runHook preInstall
    ./build.sh all
    mkdir -p $out/share/app-info/{icons/nixos,xmls}
    cp dest/*.gz $out/share/app-info/xmls/
    cp -r dest/icons/64x64 $out/share/app-info/icons/nixos/
    cp -r dest/icons/128x128 $out/share/app-info/icons/nixos/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Appstream data for NixOS";
    homepage = "https://github.com/vlinkz/nixos-appstream-data";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
