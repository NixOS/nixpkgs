{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
  gitUpdater,
  zathura,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "girara";
  version = "2026.07.18";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "girara";
    tag = finalAttrs.version;
    hash = "sha256-Q4IbB8Wecob9NH6UPqyIifyd3D+IpMCfe725U3htR+s=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  mesonFlags = [
    "-Ddocs=disabled" # docs do not seem to be installed
  ];

  passthru = {
    updateScript = gitUpdater { };
    tests = {
      inherit zathura;
    };
  };

  meta = {
    homepage = "https://pwmt.org/projects/girara";
    description = "User interface library";
    longDescription = ''
      girara is a library that implements a GTK based VIM-like user interface
      that focuses on simplicity and minimalism.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mithicspirit ];
  };
})
