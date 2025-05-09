{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  which,
  pkg-config,
  makeBinaryWrapper,
  libxkbcommon,
  wayland,
  appstream-glib,
  desktop-file-utils,
  intltool,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-notifications";
  version = "1.0.0-alpha.7";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-notifications";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-xcGmcOoxHb7gj6fW7xPZ5R0MTkMVXNJgvr9d5LPy9kw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7EDe1OjGS6Xl0N/BrZG8lzWO0pFbwiEp+kn6WyydJQM=";

  nativeBuildInputs = [
    just
    which
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    libxkbcommon
    wayland
    appstream-glib
    desktop-file-utils
    intltool
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-notifications"
  ];

  postInstall = ''
    wrapProgram $out/bin/cosmic-notifications \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-notifications";
    description = "Notifications for the COSMIC Desktop Environment";
    mainProgram = "cosmic-notifications";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}
