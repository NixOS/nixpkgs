{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk4,
  libgee,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "live-chart";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "lcallarec";
    repo = "live-chart";
    rev = finalAttrs.version;
    hash = "sha256-SOZJ9sVrmsZybs5BVXWmqBJ/P7SZI/X8TGWHXGvXAU8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gtk4
    libgee
  ];

  strictDeps = true;

  meta = {
    description = "Real-time charting library for Vala and GTK4 based on Cairo";
    homepage = "https://github.com/lcallarec/live-chart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
