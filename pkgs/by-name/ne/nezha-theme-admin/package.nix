{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "nezha-theme-admin";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "admin-frontend";
    tag = "v${version}";
    hash = "sha256-V9Vdvh66oH8cKd8vtKDHbKU5bpgSrjvgKvGo5R9E0Ao=";
  };

  # TODO: Switch to the bun build function once available in nixpkgs
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-I9oV0avnALw5BUD4hyO2FORtU59KINLWT7widUPsZtE=";

  npmPackFlags = [ "--ignore-scripts" ];

  npmBuildScript = "build-ignore-error";

  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = {
    description = "Nezha monitoring admin frontend";
    homepage = "https://github.com/nezhahq/admin-frontend";
    changelog = "https://github.com/nezhahq/admin-frontend/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
