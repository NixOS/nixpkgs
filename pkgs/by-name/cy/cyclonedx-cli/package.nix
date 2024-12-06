{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "cyclonedx-cli";
  version = "0.27.2";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-cli";
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "CycloneDX CLI tool for SBOM analysis, merging, diffs and format conversions";
    homepage = "https://github.com/CycloneDX/cyclonedx-cli";
    changelog = "https://github.com/CycloneDX/cyclonedx-cli/releases/tag/v${version}";
    maintainers = (with maintainers; [ thillux ]) ++ teams.cyberus.members;
    license = licenses.asl20;
    platforms = with platforms; (linux ++ darwin);
    mainProgram = "cyclonedx";
  };
}
