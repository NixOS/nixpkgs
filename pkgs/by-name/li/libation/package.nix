{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, wrapGAppsHook

, libX11
, libICE
, libSM
, libXi
, libXcursor
, libXext
, libXrandr
, fontconfig
, glew
, gtk3
}:

buildDotnetModule rec {
  pname = "libation";
  version = "11.1.0";

  src = fetchFromGitHub {
    owner = "rmcrackan";
    repo = "Libation";
    rev = "v${version}";
    hash = "sha256-NxG1H8lj+aBpgKj03CDpX/tLT0SxDS3pnZGQ2ultBnQ=";
  };

  sourceRoot = "${src.name}/Source";

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  nugetDeps = ./deps.nix;

  dotnetFlags = [ "-p:PublishReadyToRun=false" ];

  projectFile = [
    "LibationAvalonia/LibationAvalonia.csproj"
    "LibationCli/LibationCli.csproj"
    "HangoverAvalonia/HangoverAvalonia.csproj"
  ];

  nativeBuildInputs = [ wrapGAppsHook ];

  runtimeDeps = [
    # For Avalonia UI
    libX11
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
    fontconfig
    glew
    # For file dialogs
    gtk3
  ];

  postInstall = ''
    install -Dm644 LoadByOS/LinuxConfigApp/libation_glass.svg $out/share/icons/hicolor/scalable/apps/${pname}.svg
    install -Dm644 LoadByOS/LinuxConfigApp/Libation.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
        --replace "/usr/bin/libation" "${meta.mainProgram}"
  '';

  # wrap manually, because we need lower case excutables
  dontDotnetFixup = true;

  preFixup = ''
    # remove binaries for other platform, like upstream does
    pushd $out/lib/${pname}
    rm -f *.x86.dll *.x64.dll
    ${lib.optionalString (stdenv.system != "x86_64-linux") "rm -f *.x64.so"}
    ${lib.optionalString (stdenv.system != "aarch64-linux") "rm -f *.arm64.so"}
    ${lib.optionalString (stdenv.system != "x86_64-darwin") "rm -f *.x64.dylib"}
    ${lib.optionalString (stdenv.system != "aarch64-darwin") "rm -f *.arm64.dylib"}
    popd

    wrapDotnetProgram $out/lib/${pname}/Libation $out/bin/libation
    wrapDotnetProgram $out/lib/${pname}/LibationCli $out/bin/libationcli
    wrapDotnetProgram $out/lib/${pname}/Hangover $out/bin/hangover
  '';

  meta = {
    changelog = "https://github.com/rmcrackan/Libation/releases/tag/${src.rev}";
    description = "An Audible audiobook manager";
    homepage = "https://github.com/rmcrackan/Libation";
    license = lib.licenses.gpl3Only;
    mainProgram = "libation";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
