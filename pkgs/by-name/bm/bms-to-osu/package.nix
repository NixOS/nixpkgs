{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  ncurses,
  ffmpeg,
}:

let
  pname = "bms-to-osu";
  version = "2.5-unstable-2025-01-14"; # 2.5 crashes at runtime due to missing kernel32.dll
in
buildDotnetModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "QingQiz";
    repo = "BmsToOsu";
    rev = "e6b9dbf44ccdda7db15bf28e32d1fc1e5431319f"; # tag = "v${version}";
    hash = "sha256-JaehaKjV2fGyH6hAKwoo0t2B+hRWOjpQoIJpZq8J8C8=";
  };

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    "${ffmpeg}/bin"
  ];

  nugetDeps = ./deps.json;
  projectFile = "BmsToOsu.sln";
  executables = [ "BmsToOsu" ];
  runtimeDeps = [ ncurses ];

  meta = {
    description = "Convert BMS files to osu! beatmap files";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    homepage = "https://github.com/QingQiz/BmsToOsu";
    platforms = lib.platforms.unix;
    mainProgram = "BmsToOsu";
  };
}
