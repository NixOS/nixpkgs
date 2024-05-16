{ buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, copyDesktopItems
, makeDesktopItem
, lib
, fontconfig
, libX11
, libXcursor
, libICE
, libSM
, runCommandLocal
}:
let
  version = "6.4.8";

  src = fetchFromGitHub {
    owner = "retrospy";
    repo = "RetroSpy";
    rev = "v${version}";
    hash = "sha256-0rdLdud78gnBX8CIdG81caJ1IRoIjGzb7coP4huEPDA=";
  };

  executables = [
    "RetroSpy"
    "GBPemu"
    "GBPUpdater"
    "UsbUpdater"
  ];

  retrospy-icons = runCommandLocal "retrospy-icons" { } ''
    mkdir -p $out/share/retrospy
    ${builtins.concatStringsSep "\n" (map (e: "cp ${src}/${e}.ico $out/share/retrospy/${e}.ico") executables)}
  '';
in
buildDotnetModule {
  pname = "retrospy";
  inherit version;

  inherit src;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  runtimeDeps = [
    fontconfig
    libX11
    libICE
    libXcursor
    libSM
  ];

  projectFile = [
    "RetroSpyX/RetroSpyX.csproj"
    "GBPemuX/GBPemuX.csproj"
    "GBPUpdaterX2/GBPUpdaterX2.csproj"
    "UsbUpdaterX2/UsbUpdaterX2.csproj"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_7_0;

  nugetDeps = ./deps.nix;

  inherit executables;

  passthru.updateScript = ./update.sh;

  desktopItems = map
    (e: (makeDesktopItem {
      name = e;
      exec = e;
      icon = "${retrospy-icons}/share/retrospy/${e}.ico";
      desktopName = "${e}";
      categories = [ "Utility" ];
      startupWMClass = e;
    }))
    executables;

  meta = {
    description = "Live controller viewer for Nintendo consoles as well as many other retro consoles and computers";
    homepage = "https://retro-spy.com/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.naxdy ];
    platforms = lib.platforms.linux;
  };
}

