{
  fetchFromGitLab,
  lib,
  libpulseaudio,
  libtiff,
  meson,
  ninja,
  pkg-config,
  scdoc,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdng";
  version = "0.2.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    owner = "megapixels-org";
    repo = "libdng";
    tag = finalAttrs.version;
    hash = "sha256-2Kwz5K37I3HnnKePyY4nKYwnGHP09vr6IThiuKd3EfQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    libpulseaudio
    libtiff
  ];

  doCheck = true;

  meta = {
    changelog = "https://gitlab.com/megapixels-org/libdng/-/tags/${finalAttrs.src.tag}";
    description = "Interface library between libtiff and the world to make sure the output is valid DNG";
    homepage = "https://gitlab.com/megapixels-org/libdng";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.linux;
  };
})
