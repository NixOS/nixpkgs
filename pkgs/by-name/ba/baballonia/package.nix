{
  cmake,
  opencv,
  udev,
  libjpeg,
  libGL,
  fontconfig,
  xorg,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchurl,
  stdenv,
}:
let
  internal = fetchurl {
    # This URL is weird but this is the primary source
    url = "http://217.154.52.44:7771/builds/trainer/1.0.0.0.zip";
    hash = "sha256-Amlf6OIJyiU0vdMoXAzxXPnlX4TE9hQrjDMzbkMOzDE=";
  };

  dotnet = dotnetCorePackages.dotnet_8;

  opencvsharp = stdenv.mkDerivation rec {
    pname = "opencvsharp";
    version = "4.11.0.20250507";

    src = fetchFromGitHub {
      owner = "shimat";
      repo = "opencvsharp";
      tag = version;
      hash = "sha256-CkG4Kx/AkZqyhtclMfS51a9a9R+hsqBRlM4fry32YJ0=";
    };
    nativeBuildInputs = [ cmake ];
    buildInputs = [ opencv ];
    sourceRoot = "${src.name}/src";

    cmakeFlags = [ (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5") ];
  };
in
buildDotnetModule (finalAttrs: {
  version = "1.1.0.8";
  pname = "baballonia";

  patches = [ ./0001-disable-auto-updating.patch ];

  buildInputs = [
    cmake
    opencv
    udev
    libjpeg
    libGL
    fontconfig
    xorg.libX11
    xorg.libSM
    xorg.libICE
    opencvsharp
  ];

  src = fetchFromGitHub {
    owner = "Project-Babble";
    repo = "Baballonia";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OnLCK/T7b0NsExKEv95a0lM9TccJkI/uLGIe+oz3Rtw=";
    fetchSubmodules = true;
  };

  dotnetSdk = dotnet.sdk;
  nugetDeps = ./deps.json;
  dotnetRuntime = dotnet.runtime;
  projectFile = "src/Baballonia.Desktop/Baballonia.Desktop.csproj";

  runtimeDeps = [ udev ];

  makeWrapperArgs = [
    "--chdir"
    "${placeholder "out"}/lib/baballonia"
  ];

  postUnpack = ''
    ln -s ${internal} $sourceRoot/src/Baballonia.Desktop/_internal.zip
  '';

  preFixup = ''
    mv $out/bin/lib*.{so,so.dbg} $out/lib
  '';

  postFixup = ''
    mkdir -p $out/lib/baballonia/Modules
    mv $out/bin/Baballonia.Desktop $out/bin/baballonia
  '';

  meta = {
    mainProgram = "baballonia";
    platforms = lib.platforms.linux;
    homepage = "https://github.com/Project-Babble/Baballonia";
    description = "Free and open source eye and face tracking for social VR";
    license = lib.licenses.babble1;
    maintainers = with lib.maintainers; [
      zenisbestwolf
      ShyAssassin
    ];
  };
})
