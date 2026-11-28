{
  lib,
  stdenv,
  dotnetCorePackages,
  buildDotnetModule,
  fetchFromGitHub,
  libglvnd,
  makeDesktopItem,
  copyDesktopItems,
}:

buildDotnetModule rec {
  pname = "mqttmultimeter";
  version = "1.10.0.318";

  src = fetchFromGitHub {
    owner = "chkr1011";
    repo = "mqttMultimeter";
    rev = "v" + version;
    hash = "sha256-I11ax0npLGxb/2LIdTuzCmBKmCM6HnWXKtErlRP+9gw=";
  };

  sourceRoot = "${src.name}/Source";

  projectFile = [ "mqttMultimeter.sln" ];
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  executables = [ "mqttMultimeter" ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  postInstall = ''
    rm -rf $out/lib/${lib.toLower pname}/runtimes/{*musl*,win*}
  '';

  runtimeDeps = [
    libglvnd
  ];

  desktopItems = [
    (makeDesktopItem {
      name = meta.mainProgram;
      exec = meta.mainProgram;
      icon = meta.mainProgram;
      desktopName = meta.mainProgram;
      genericName = meta.description;
      comment = meta.description;
      type = "Application";
      categories = [ "Network" ];
      startupNotify = true;
    })
  ];

  meta = {
    mainProgram = builtins.head executables;
    description = "MQTT traffic monitor";
    homepage = "https://github.com/chkr1011/mqttMultimeter";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.linux;
  };
}
