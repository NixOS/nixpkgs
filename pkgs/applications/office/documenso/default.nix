{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodePackages,
  nix-update-script,
}:
let
  version = "0.9";
in
buildNpmPackage {
  pname = "documenso";
  inherit version;

  src = fetchFromGitHub {
    owner = "documenso";
    repo = "documenso";
    rev = "v${version}";
    hash = "sha256-uKOJVZ0GRHo/CYvd/Ix/tq1WDhutRji1tSGdcITsNlo=";
  };

  preBuild = ''
    # somehow for linux, npm is not finding the prisma package with the
    # packages installed with the lockfile.
    # This generates a prisma version incompatibility warning and is a kludge
    # until the upstream package-lock is modified.
    ${nodePackages.prisma}/bin/prisma generate
  '';

  npmDepsHash = "sha256-+JbvFMi8xoyxkuL9k96K1Vq0neciCGkkyZUPd15ES2E=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r node_modules $out/
    cp package-lock.json $out
    cp apps/web/package.json $out
    cp -r apps/web/public $out/
    cp -r apps/web/.next $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "The Open Source DocuSign Alternative.";
    homepage = "https://github.com/documenso/documenso";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.unix;
  };
}
