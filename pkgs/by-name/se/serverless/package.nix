{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "serverless";
  version = "3.38.0";

  src = fetchFromGitHub {
    owner = "serverless";
    repo = "serverless";
    rev = "v${version}";
    hash = "sha256-DplJRJOdIpZfIvpyPo9VcaXCHVPWB8FwhOH4vISUh3Q=";
  };

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-cCJb8DTIPkvsXEP6TOO/jVH1+pM3+6hKPMH2cJukeCQ=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/serverless/serverless/blob/${src.rev}/CHANGELOG.md";
    description = "Build applications on AWS Lambda and other next-gen cloud services, that auto-scale and only charge you when they run";
    homepage = "https://serverless.com";
    license = lib.licenses.mit;
    mainProgram = "serverless";
    maintainers = [ ];
    knownVulnerabilities = [
      "CVE-2025-7783: form-data uses unsafe random function in form-data for choosing boundary"
      "CVE-2025-64718: js-yaml has prototype pollution in merge (<<)"
      "CVE-2022-25883: semver vulnerable to Regular Expression Denial of Service"
      "and 20 others"
      "Serverless v3 is no longer maintained by Serverless, and v4 is not suitable for packaging in nixpkgs."
      "(See https://github.com/NixOS/nixpkgs/pull/464100 for details.)"
    ];
  };
}
