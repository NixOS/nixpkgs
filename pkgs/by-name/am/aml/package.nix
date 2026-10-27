{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aml";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "aml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-10gm6YphZrpLShj3NUj/AG24dSVLZAZbbnXr7GiF4DI=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  strictDeps = true;

  __structuredAttrs = true;

  meta = {
    description = "Andri's Main Loop";
    homepage = "https://github.com/any1/aml";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
