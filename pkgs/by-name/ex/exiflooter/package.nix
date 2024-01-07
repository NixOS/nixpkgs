{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "exiflooter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aydinnyunus";
    repo = "exiflooter";
    rev = "v${version}";
    hash = "sha256-E7fxV+w8N9xi8UuaKBTZBzPjIHJt9/U+oVIu2+Ond+Y=";
  };

  vendorHash = "sha256-uV7O2H3gPQ+kFdEHLgM+v+TXn+87QfFwOAEQpnKQIQk=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "ExifLooter finds geolocation on all image urls and directories also integrates with OpenStreetMap";
    homepage = "https://github.com/aydinnyunus/exiflooter";
    changelog = "https://github.com/aydinnyunus/exifLooter/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "exiflooter";
  };
}
