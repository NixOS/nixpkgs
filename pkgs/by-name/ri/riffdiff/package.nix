{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  riffdiff,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "riffdiff";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    tag = finalAttrs.version;
    hash = "sha256-dd2Qt67qpgQBtiQnFEq5oY69uZ3Vb+HQYYKyAyelqKI=";
  };

  cargoHash = "sha256-jr7ejJlrQ97khuX8A9ctDYnSf+0zt2f7YZzbZX+9WWE=";

  passthru = {
    tests.version = testers.testVersion { package = riffdiff; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    changelog = "https://github.com/walles/riff/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      johnpyp
      getchoo
    ];
    mainProgram = "riff";
  };
})
