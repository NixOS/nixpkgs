{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxcb,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustfetch";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lemuray";
    repo = "rustfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7+25SYYpOwbJM3UofTjk8hAuDVQ33tUge+2k1oSRvvY=";
  };
  cargoHash = "sha256-/D6y6h86V7qUfJqXW6XXTHAyiqwNJAfSQOLHxNfajv8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  checkFlags = [
    # requires os calls which will error out to "Permission denied" in the sandbox
    "--skip=test_no_pretty_name"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "CLI tool designed to fetch system information in the fastest and safest way possible";
    homepage = "https://github.com/lemuray/rustfetch";
    changelog = "https://github.com/lemuray/rustfetch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lefaucheur0769 ];
    mainProgram = "rustfetch";
  };
})
