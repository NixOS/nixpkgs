{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flamelens";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "flamelens";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b7lRMyeX/aL1ziSaLBUxChrwXeKNhcCShjGY6ANYqhY=";
  };

  cargoHash = "sha256-QcEN83Cd92i0Ll+8uWSLREKk5i0STwhAKTCx48BiI6A=";

  meta = {
    description = "Interactive flamegraph viewer in the terminal";
    homepage = "https://github.com/YS-L/flamelens";
    changelog = "https://github.com/YS-L/flamelens/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.averdow ];
  };
})
