{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  cargo,
  rustc,
  rustPlatform,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minimage";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "lode-org";
    repo = "minimage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Y9UFgj7hEiXcRNpUa0cHx6aT01QomJWCvvAuBfXya0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-8NSCv17ACkQbkBnycIZ3K9mUUOWwYX4u7OMii2F2znk=";
  };

  strictDeps = true;
  __structuredAttrs = true;
  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  mesonFlags = [ (lib.mesonBool "with_examples" false) ];

  meta = {
    description = "Minimum-image convention for periodic parallelepiped cells";
    homepage = "https://lode-org.github.io/minimage/";
    changelog = "https://github.com/lode-org/minimage/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iedame ];
    platforms = lib.platforms.unix;
  };
})
