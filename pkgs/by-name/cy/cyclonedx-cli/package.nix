{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "cyclonedx-cli";
  version = "0.27.2";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-cli";
    tag = "v${version}";
    hash = "sha256-QU/MaT8iIf/9VpOb2mixOfOtG/J+sE7S0mT6BKYQnlI=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  nugetDeps = ./deps.json;

  preFixup = ''
    cd $out/bin
    find . ! -name 'cyclonedx' -type f -exec rm -f {} +
  '';

  postPatch = ''
    substituteInPlace src/cyclonedx/cyclonedx.csproj tests/cyclonedx.tests/cyclonedx.tests.csproj \
      --replace-fail 'net6.0' 'net8.0'
  '';

  meta = {
    description = "CycloneDX CLI tool for SBOM analysis, merging, diffs and format conversions";
    homepage = "https://github.com/CycloneDX/cyclonedx-cli";
    changelog = "https://github.com/CycloneDX/cyclonedx-cli/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ thillux ];
    teams = [ lib.teams.ctrl-os ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; (linux ++ darwin);
    mainProgram = "cyclonedx";
  };
}
