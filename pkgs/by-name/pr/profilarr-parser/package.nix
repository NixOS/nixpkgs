{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  profilarr,
}:
buildDotnetModule (finalAttrs: {
  pname = "profilarr-parser";
  inherit (profilarr) version src;

  strictDeps = true;
  __structuredAttrs = true;

  projectFile = "src/services/parser/Parser.csproj";
  nugetDeps = [ ];
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  executables = [ "Parser" ];

  # Upstream redirects output and intermediates to dist/parser, outside the
  # project directory expected by buildDotnetModule's restore/build phases.
  postPatch = ''
    rm -f src/services/parser/Directory.Build.props
  '';

  postFixup = ''
    mv "$out/bin/Parser" "$out/bin/profilarr-parser"
  '';

  meta = {
    description = "Release-title and custom-format parser for Profilarr";
    homepage = "https://github.com/Dictionarry-Hub/profilarr";
    changelog = "https://github.com/Dictionarry-Hub/profilarr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ shgew ];
    mainProgram = "profilarr-parser";
    platforms = lib.platforms.linux;
  };
})
