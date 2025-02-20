{
  lib,
  callPackage,
  pkgsCross,
  stdenvNoCC,
  buildDotnetModule,
  fetchFromGitHub,
  fetchpatch,
  dotnetCorePackages,

  is32Bit ? stdenvNoCC.hostPlatform.parsed.cpu.bits == 32,
}:
if (!stdenvNoCC.hostPlatform.isWindows) then
  callPackage ./wrapper.nix {
    inherit (if is32Bit then pkgsCross.mingw32 else pkgsCross.mingwW64) dnspy;
    inherit is32Bit;
  }
else
  buildDotnetModule rec {
    pname = "dnspy${lib.optionalString is32Bit "32"}";
    version = "6.5.1";

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
    nugetDeps = ./deps.json;

    dotnet-sdk = dotnetCorePackages.sdk_8_0;
    dotnet-runtime =
      with dotnetCorePackages;
      combinePackages [
        runtime_8_0
        windowsdesktop_8_0
      ];

    dotnetFlags = [ "-p:TargetFramework=net8.0-windows" ];

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
      platforms = [
        "x86_64-windows"
        "i686-windows"
      ];
      mainProgram = "dnSpy.exe";
    };
  }
