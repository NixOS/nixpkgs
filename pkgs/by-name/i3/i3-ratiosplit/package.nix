{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "i3-ratiosplit";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "333fred";
    repo = "i3-ratiosplit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-46/ioZdKVFkLhSkpcqHB7GGNSF5S+jBaolEwMX/J1Xk=";
  };

  cargoHash = "sha256-no5fJ5nlwyS/PVi9J5Ek3c3Rp7A3MflpReo9kwJrj6U=";

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = {
    description = "Resize newly created windows";
    mainProgram = "i3-ratiosplit";
    homepage = "https://github.com/333fred/i3-ratiosplit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ svrana ];
    platforms = lib.platforms.linux;
  };
})
