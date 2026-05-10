{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dtsfmt";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mskelton";
    repo = "dtsfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2DKfmWnz9Iaxs4VN16BHOzsncEFXaX2mwR2Ta9AyYn0=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-BbX/IEfn5qhyW/IkgARfxD0rTx+hcoq8TmoDmUqclHQ=";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Auto formatter for device tree files";
    homepage = "https://github.com/mskelton/dtsfmt";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ toodeluna ];
    mainProgram = "dtsfmt";
  };
})
