{
  stdenv,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nano,
  wkhtmltopdf,
}:

buildDotnetModule (finalAttrs: {
  pname = "calcpad";
  version = "7.6.0";

  src = fetchFromGitHub {
    owner = "proektsoftbg";
    repo = "calcpad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2rBaHnr+80Dec1NUrvrqD8VvZthS55+imFDimQtDkyA=";
  };

  patches = [
    # The program uses a post-install script to install the configuration file,
    # but that post-install script is not ran. Also, the program assumes that the
    # configuration file on Linux will be located at `~/Documents/.config/calcpad`,
    # which is not common. Patched to use `XDG_CONFIG_HOME` with a fallback to `~/.config`.
    ./01-update-config-settings.patch
  ];

  postPatch = ''
    substituteInPlace Calcpad.Tests/Calcpad.Tests.csproj \
      --replace-fail '..\Calcpad.core\Calcpad.Core.csproj' '..\Calcpad.Core\Calcpad.Core.csproj'

    substituteInPlace Calcpad.Cli/Calcpad.Cli.csproj \
      --replace-fail 'Include="doc\*\*"' 'Include="doc\**"' \
      --replace-fail 'Include="Examples\*\*"' 'Include="Examples\**"' \
      --replace-fail 'Include="Syntax\*\*"' 'Include="Syntax\**"'

    substituteInPlace Calcpad.Cli/Converter.cs \
      --replace-fail "/usr/bin/wkhtmltopdf" "${wkhtmltopdf}/bin/wkhtmltopdf"

    substituteInPlace Calcpad.Cli/doc/template.html \
      --replace-fail "https://calcpad.local/jquery-3.6.3.min.js" "jquery-3.6.3.min.js"
  '';

  # The CLI tool is packaged as the GUI uses WPF, which is not natively
  # supported on Linux - see https://github.com/Proektsoftbg/Calcpad/issues/94.
  projectFile = "Calcpad.Cli/Calcpad.Cli.csproj";
  testProjectFile = "Calcpad.Tests/Calcpad.Tests.csproj";

  nugetDeps = ./deps.json;
  runtimeDeps = [
    nano
    wkhtmltopdf
  ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  doCheck = true;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "CLI tool for mathematical and engineering calculations";
    homepage = "https://calcpad.eu";
    changelog = "https://github.com/Proektsoftbg/Calcpad/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magicquark ];
    mainProgram = "Cli";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
