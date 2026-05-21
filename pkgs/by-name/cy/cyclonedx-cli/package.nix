{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "cyclonedx-cli";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-cli";
    tag = "v${version}";
    hash = "sha256-a9jUJqj/h2u2SrIQkQV8aFSzys+RVEI2yNlHTJpll+M=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
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
