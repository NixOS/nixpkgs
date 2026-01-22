{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.19";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ntfbwaVZM4wtoDaaFo+Y7RHSft3KZ29DMsNiTvhiaXs=";
  };

  cargoHash = "sha256-0pDm/e1xisPLqdTe10kleoejQfuOZoZW6l/83Splz/Y=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = {
    description = "Wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    changelog = "https://github.com/dtolnay/faketty/releases/tag/${version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
    mainProgram = "faketty";
  };
}
