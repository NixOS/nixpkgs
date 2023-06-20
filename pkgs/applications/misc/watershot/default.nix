{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wayland
, libxkbcommon
, fontconfig
, makeWrapper
, grim
}:
rustPlatform.buildRustPackage rec {
  pname = "watershot";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Kirottu";
    repo = "watershot";
    rev = "v${version}";
    hash = "sha256-8GqO7Y0d+AoYr3Us3FEfNobrQNSw7XyGwmZz5HkVvDg=";
  };

  cargoHash = "sha256-yJD7c/I3rwzczcrxbD8sinzP7bjMzhWWAVcCFCsTdeo=";

  nativeBuildInputs = [ pkg-config wayland makeWrapper ];

  buildInputs = [ wayland fontconfig libxkbcommon ];

  postInstall = ''
    wrapProgram $out/bin/watershot \
      --prefix PATH : ${lib.makeBinPath [ grim ]}
  '';

  meta = with lib; {
    platforms = with platforms; linux;
    description = "A simple wayland native screenshot tool";
    homepage = "https://github.com/Kirottu/watershot";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lord-valen ];
  };
}
