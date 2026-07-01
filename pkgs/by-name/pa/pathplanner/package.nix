{ lib, fetchFromGitHub, stdenv, flutter, makeDesktopItem, pkg-config, util-linux }:

let
  desktopItem = makeDesktopItem {
    type = "Application";
    name = "PathPlanner";
    desktopName = "PathPlanner";
    comment = "An autonomous path planning tool for FIRST Robotics Competition teams";
    icon = "pathplanner";
    exec = "pathplanner %u";
  };
in
flutter.buildFlutterApplication rec {
  pname = "pathplanner";
  version = "2024.1.4";

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = "pathplanner";
    rev = "v${version}";
    hash = "sha256-ILERA6iUwKJRi3xCUliEFSHJmL+3ojjMyh+QUzpjuzk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ util-linux.lib ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  vendorHash = "sha256-ILERA6iUwKJRi3xCUliEFSHJmL+3ojjMyh+QUzpjuzk=";

  postInstall = ''
    install -Dm444 "${desktopItem}/share/applications/"* -t $out/share/applications/
    install -Dm444 ${src}/images/icon.png $out/share/pixmaps/pathplanner.png
  '';

  meta = with lib; {
    description = "An autonomous path planning tool for FIRST Robotics Competition teams";
    homepage = "https://pathplanner.dev";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ max-niederman ];
  };
}
