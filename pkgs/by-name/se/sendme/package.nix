{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sendme";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pylf7QuIn5Dm7V31VwfBrkI0W8LML1XoHKvxF/jrRcw=";
  };

  cargoHash = "sha256-4GRyEojm115nTjX2/zZWe/Jv8x6DOFY4WpzIR0pm8H4=";

  # The tests require contacting external servers.
  doCheck = false;

  meta = {
    description = "Tool to send files and directories, based on iroh";
    homepage = "https://iroh.computer/sendme";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "sendme";
  };
})
