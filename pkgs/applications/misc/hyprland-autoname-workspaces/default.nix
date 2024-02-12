{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-autoname-workspaces";
  version = "1.1.13";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprland-autoname-workspaces";
    rev = version;
    hash = "sha256-JEzsbJcDX/qx1CMy+3UwcHOwFLPqyAG58MpGMtdSyYY=";
  };

  cargoHash = "sha256-Rpivw4VCVHjZywDwr4pajfGv/mkOdVrXVT/9Oe2Hw44=";

  meta = with lib; {
    description = "Automatically rename workspaces with icons of started applications";
    homepage = "https://github.com/hyprland-community/hyprland-autoname-workspaces";
    license = licenses.isc;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprland-autoname-workspaces";
    platforms = platforms.linux;
  };
}
