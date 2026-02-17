{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustfetch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "lemuray";
    repo = "rustfetch";
    tag = finalAttrs.version;
    hash = "sha256-gyWnahj1A+iXUQlQ1O1H1u7K5euYQOld9qWm99Vjaeg=";
  };
  cargoHash = "sha256-9atn5qyBDy4P6iUoHFhg+TV6Ur71fiah4oTJbBMeEy4=";

  meta = {
    description = "A CLI tool designed to fetch system information in the fastest and safest way possible";
    homepage = "https://github.com/lemuray/rustfetch";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ LeFaucheur0769 ];
    mainProgram = "rustfetch";
  };
})
