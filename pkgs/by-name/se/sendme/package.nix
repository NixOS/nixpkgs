{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sendme";
  version = "0.36.1";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VvT6tlgZHof4X8fe3WLVq/9nJDNSkQFF/Chhl/LR4gc=";
  };

  cargoHash = "sha256-ktV/+lgaPphD5axbP1f19bgQfx/YIhXXpj9yFbW4xzM=";

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
