{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "cyclonedx-cli";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-cli";
    tag = "v${version}";
    hash = "sha256-XP6Zz9JITIw6xUefOkLLjoHUDsnhsOKdtY5S5xbkejU=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  nugetDeps = ./deps.json;

  preFixup = ''
    cd $out/bin
    find . ! -name 'cyclonedx' -type f -exec rm -f {} +
  '';

  meta = {
    description = "CycloneDX CLI tool for SBOM analysis, merging, diffs and format conversions";
    homepage = "https://github.com/CycloneDX/cyclonedx-cli";
    changelog = "https://github.com/CycloneDX/cyclonedx-cli/releases/tag/v${version}";
    maintainers = with lib.maintainers; [
      blitz
      thillux
    ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; (linux ++ darwin);
    mainProgram = "cyclonedx";
  };
}
