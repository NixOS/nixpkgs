{
  lib,
  stdenvNoCC,
  fetchpatch,
  lndir,
  fetchFromGitHub,
  buildDotnetModule,
  pkgsCross,
  is32bit ? false,
  wine,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  icoutils,
  writeShellScript,
  nix-update,
}:
stdenvNoCC.mkDerivation rec {
  pname = "dnspy${lib.optionalString is32bit "32"}";
  version = "6.5.1";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  unwrapped = buildDotnetModule {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "dnSpyEx";
      repo = "dnSpy";
      rev = "v${version}";
      hash = "sha256-ttGQpwFLj7px1z+SZv1eelOkXA9bbG0F5nGUSNCsC6k=";
      fetchSubmodules = true;
    };

    patches = [
      # Disable WPF hardware acceleration when running dnSpy under Wine
      (fetchpatch {
        url = "https://github.com/dnSpyEx/dnSpy/commit/f20c00583c15d91214dee7e97e4f680a48e891a5.patch";
        hash = "sha256-hpSXjm01ohePRmNopb0sm/KQM825gRm5kLznzauB81c=";
      })

      # Add Liberation Mono as monospace font fallback for Wine compatibility
      (fetchpatch {
        url = "https://github.com/dnSpyEx/dnSpy/commit/5ea1e361a457c7602832be2768655410294c930b.patch";
        hash = "sha256-FgDxqFlPPIWE91O4Ie6tIYIbD3O/U33i+3XtD1kB7is=";
      })
    ];

    projectFile = [
      "dnSpy/dnSpy/dnSpy.csproj"
      "dnSpy/dnSpy.Console/dnSpy.Console.csproj"

      "Extensions/ILSpy.Decompiler/dnSpy.Decompiler.ILSpy/dnSpy.Decompiler.ILSpy.csproj"
      "Extensions/dnSpy.Analyzer/dnSpy.Analyzer.csproj"
      "Extensions/dnSpy.AsmEditor/dnSpy.AsmEditor.csproj"
      "Extensions/dnSpy.BamlDecompiler/dnSpy.BamlDecompiler.csproj"
      "Extensions/dnSpy.Debugger/dnSpy.Debugger/dnSpy.Debugger.csproj"
      "Extensions/dnSpy.Debugger/dnSpy.Debugger.DotNet/dnSpy.Debugger.DotNet.csproj"
      "Extensions/dnSpy.Debugger/dnSpy.Debugger.DotNet.CorDebug/dnSpy.Debugger.DotNet.CorDebug.csproj"
      "Extensions/dnSpy.Debugger/dnSpy.Debugger.DotNet.Mono/dnSpy.Debugger.DotNet.Mono.csproj"
      "Extensions/dnSpy.Scripting.Roslyn/dnSpy.Scripting.Roslyn.csproj"
    ];
    nugetDeps = ./deps.nix;

    dotnet-sdk =
      (if is32bit then pkgsCross.mingw32 else pkgsCross.mingwW64)
      .buildPackages.dotnetCorePackages.sdk_8_0;
    dotnet-runtime = null;

    runtimeId = "win-${if is32bit then "x86" else "x64"}";
    dotnetFlags = [ "-p:TargetFramework=net8.0-windows" ];
    selfContainedBuild = true;

    dontDotnetCheck = true;
    dontDotnetFixup = true;

    postInstall = ''
      icon_name=dnSpy${lib.optionalString is32bit "-x86"}
      ${lib.getExe' icoutils "icotool"} -x dnSpy/dnSpy/Images/$icon_name.ico
      for f in $icon_name_*.png; do
        res=$(basename "$f" | cut -d "_" -f3 | cut -d "x" -f1-2)
        install -vD "$f" "$out/share/icons/hicolor/$res/apps/$pname.png"
      done
    '';

    meta = {
      description = ".NET debugger and assembly editor";
      homepage = "https://github.com/dnSpyEx/dnSpy";
      sourceProvenance = with lib.sourceTypes; [
        fromSource
        binaryBytecode
        binaryNativeCode
      ];
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ js6pak ];
    };
  };

  wrapper = writeShellScript "dnspy-wrapper" ''
    export WINE="${lib.getExe wine}"
    export WINEPREFIX="''${DNSPY_HOME:-"''${XDG_DATA_HOME:-"''${HOME}/.local/share"}/dnSpy"}/wine${lib.optionalString is32bit "32"}"
    export WINEDEBUG=-all

    if [ ! -d "$WINEPREFIX" ]; then
      mkdir -p "$WINEPREFIX"
      ${lib.getExe' wine "wineboot"} -u
    fi

    exec "$WINE" "''${ENTRYPOINT:-@out@/lib/${pname}/dnSpy.exe}" "$@"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ${lib.getExe lndir} -silent ${unwrapped} $out

    mkdir $out/bin
    cp ${wrapper} $out/bin/${meta.mainProgram}
    substituteInPlace $out/bin/${meta.mainProgram} \
      --subst-var-by out $out

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    desktopName = "dnSpy" + (lib.optionalString is32bit " (32-bit)");
    comment = meta.description;
    icon = pname;
    exec = meta.mainProgram;
    categories = [ "Development" ];
  };

  passthru.updateScript = writeShellScript "update-dnspy" ''
    ${lib.getExe nix-update} "dnspy.unwrapped"
    "$(nix-build -A "dnspy.unwrapped.fetch-deps" --no-out-link)"
  '';

  meta = unwrapped.meta // {
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
