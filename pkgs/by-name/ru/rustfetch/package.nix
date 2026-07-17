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
    tag = "v${finalAttrs.version}";
    hash = "sha256-iGcxDKl36kbEi+OiH4gB2+HxP37bpqAMZguIXDzq3Jw=";
  };
  cargoHash = "sha256-87wfFczmgCft4ke/RQKi54wvqFKGRJMtqhkwQgDCedg=";

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
