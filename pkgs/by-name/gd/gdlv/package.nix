{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "gdlv";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "aarzilli";
    repo = "gdlv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YHv/PfkQh0detM3p62oDWhEG8PWCupaBhwbxz8rHRdI=";
  };

  vendorHash = null;
  subPackages = ".";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI frontend for Delve";
    mainProgram = "gdlv";
    homepage = "https://github.com/aarzilli/gdlv";
    maintainers = [
      lib.maintainers.mmlb
    ];
    license = lib.licenses.gpl3;
  };
})
