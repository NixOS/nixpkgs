{
  stdenv,
  lib,
  fetchFromCodeberg,
  pkg-config,
  meson,
  ninja,
  dbus,
  scdoc,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fyi";
  version = "1.0.4";
  src = fetchFromCodeberg {
    owner = "dnkl";
    repo = "fyi";
    rev = finalAttrs.version;
    hash = "sha256-UGkShHziREQTkQUlbFXT1144BiBApFVbCvu5A1DuoMI=";
  };

  patches = [
    # fix build w/ glibc-2.44
    (fetchpatch {
      url = "https://codeberg.org/dnkl/fyi/commit/0a663c5230f756d1161a11080d1a113664e79c21.patch";
      hash = "sha256-B4RkenK4pDAl0jYCgoZH27yUDt3evAHaYnassLaFvB4=";
      excludes = [ "CHANGELOG.md" ];
    })
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    scdoc
  ];

  buildInputs = [ dbus ];

  meta = {
    changelog = "https://codeberg.org/dnkl/fyi/releases/tag/${finalAttrs.version}";
    description = "Command line utility to create desktop notifications";
    homepage = "https://codeberg.org/dnkl/fyi";
    license = lib.licenses.mit;
    mainProgram = "fyi";
    maintainers = with lib.maintainers; [ marnym ];
    platforms = lib.platforms.linux;
  };
})
