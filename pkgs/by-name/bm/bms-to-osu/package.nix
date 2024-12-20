{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  fetchurl,
  ncurses,
  ffmpeg,
}:

let
  pname = "bms-to-osu";
  version = "2.5-unstable-2024-12-22"; # 2.5 crashes at runtime due to missing kernel32.dll
in
buildDotnetModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "QingQiz";
    repo = "BmsToOsu";
    rev = "52b5d987395c0ff1146bc9933fcc1d8f211c805f"; # tag = "v${version}";
    hash = "sha256-eq7/ZbtHLp/ooZ2S2MSXHqNeBc1sjE7/CpXRvtvUCf8=";
  };

  postPatch = ''
    sed -i 's|<TargetFramework>net6.0</|<TargetFramework>net8.0</|' BmsToOsu/BmsToOsu.csproj
  '';

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
