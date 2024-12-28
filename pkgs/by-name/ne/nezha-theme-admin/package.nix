{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "nezha-theme-admin";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "admin-frontend";
    tag = "v${version}";
    hash = "sha256-BnpcCkI6lIno5W3ZemQQf1UVa6bpwmIJ5KXg6BQ5Ur0=";
  };

  # TODO: Switch to the bun build function once available in nixpkgs
  npmDepsHash = "sha256-iXSks0LOTdbrSJdnSvzXW53wZanWjyDnL9ODcaBqpHI=";

  npmPackFlags = [ "--ignore-scripts" ];

  npmBuildScript = "build-ignore-error";

  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nezha monitoring admin frontend";
    homepage = "https://github.com/nezhahq/admin-frontend";
    changelog = "https://github.com/nezhahq/admin-frontend/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
