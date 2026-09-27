{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  go,
  _experimental-update-script-combinators,
  nix-update-script,
  writeShellApplication,
  common-updater-scripts,
  yq,
}:
let
  version = "4.15.1";
  templatesVersion = "3.1.1648";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-functions-core-tools";
    tag = version;
    hash = "sha256-qeTHGBEg4XJ2E2uLP4r5r05X+ECrujJdv9kW1MX2Dfo=";
  };

  # This contains project templates for non-dotnet languages.
  templates = fetchurl {
    url = "https://cdn.functions.azure.com/public/TemplatesApi/${templatesVersion}.zip";
    hash = "sha256-YYKBwd69TIHQKF1r8BzlzIyDLJBcCqtAbK3FhNvA+5s=";
  };
in
buildDotnetModule {
  pname = "azure-functions-core-tools";
  inherit src version;
  projectFile = "src/Cli/func/Azure.Functions.Cli.csproj";
  executables = [ "func" ];

  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0 // {
    inherit
      (dotnetCorePackages.combinePackages [
        dotnetCorePackages.sdk_9_0
        dotnetCorePackages.sdk_8_0
      ])
      packages
      targetPackages
      ;
  };
  nativeBuildInputs = [ go ];

  linkNuGetPackagesAndSources = true;
  useDotnetFromEnv = true;

  postPatch = ''
    templates_path="./out/obj/Azure.Functions.Cli/templates-staging"
    mkdir -p "$templates_path"
    cp "${templates}" "$templates_path/templates.zip"

    substituteInPlace src/Cli/func/Common/CommandChecker.cs \
      --replace-fail "CheckExitCode(\"/bin/bash" "CheckExitCode(\"${stdenv.shell}"
  '';

  passthru = {
    # expose so that update-source-version can properly update the templates version
    inherit templatesVersion templates;

    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (lib.getExe (writeShellApplication {
        name = "update-templates";
        runtimeInputs = [
          common-updater-scripts
          yq
        ];
        text = ''
          src=$(nix-build --no-out-link -A "$UPDATE_NIX_ATTR_PATH".src)
          latestTemplatesVersion=$(
            xq -r '
              .Project.PropertyGroup[] |
              select(has("TemplatesJsonVersion")) |
              .TemplatesJsonVersion' \
            "$src/eng/build/Templates.targets"
          )

          update-source-version "$UPDATE_NIX_ATTR_PATH" \
            "$latestTemplatesVersion" \
            --source-key=templates \
            --version-key=templatesVersion
        '';
      }))
    ];
  };

  meta = {
    homepage = "https://github.com/Azure/azure-functions-core-tools";
    description = "Command line tools for Azure Functions";
    mainProgram = "func";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mdarocha
      detegr
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
  };
}
