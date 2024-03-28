{ lib
, buildDotnetModule
, fetchFromGitHub
}:

buildDotnetModule rec {
  pname = "cyclonedx-cli";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-kAMSdUMr/NhsbMBViFJQlzgUNnxWgi/CLb3CW9OpWFo=";
  };

  nugetDeps = ./deps.nix;

  meta = with lib; {
    description = "CycloneDX CLI tool for SBOM analysis, merging, diffs and format conversions. ";
    homepage = "https://github.com/CycloneDX/cyclonedx-cli";
    maintainers = with maintainers; [ thillux ];
    license = licenses.asl20;
    platforms = with platforms; (linux ++ darwin);
  };
}
