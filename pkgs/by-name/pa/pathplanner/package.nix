{
  pkgs,
  stdenv,
  lib,
  fetchFromGitHub,
  flutter,
}:

flutter.buildFlutterApplication rec {
  pname = "pathplanner";
  version = "2026.1.2";

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = "pathplanner";
    rev = "v${version}";
    hash = "sha256-ocqBviTfMxjdJdEu++yqUY9JTLs1qEnP94w6HCFp5f0=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    pkgs.util-linux # For libblkid
    pkgs.xz # For liblzma
  ];

  meta = with lib; {
    description = "FRC motion profile generator and path editor for robots";
    homepage = "https://github.com/mjansen4857/pathplanner";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colepearson27 ];
  };
}
