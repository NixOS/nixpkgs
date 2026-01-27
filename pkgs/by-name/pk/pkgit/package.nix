{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNimPackage (finalAttrs: {
  pname = "pkgit";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "dacctal";
    repo = "pkgit";
    tag = finalAttrs.version;
    hash = "sha256-k9egbZD7V2EdIQRTJ8kVic7pNvAvIln5O+ke1lciCT8=";
  };

  lockFile = ./lock.json;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Compile & install packages directly from the git repository";
    homepage = "https://github.com/dacctal/pkgit";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "pkgit";
  };
})
