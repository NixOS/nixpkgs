{
  alsa-lib,
  atk,
  cairo,
  dbus,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gtk3,
  lib,
  libclang,
  makeDesktopItem,
  nix-update-script,
  pango,
  pkg-config,
  rustPlatform,
  stdenv,
}:

let
  desktopItem = makeDesktopItem {
    categories = [
      "Audio"
      "AudioVideo"
    ];
    comment = "Spotify client with native GUI written in Rust, without Electron";
    desktopName = "Psst";
    exec = "psst-gui %U";
    icon = "psst";
    name = "Psst";
    startupWMClass = "psst-gui";
  };
in
rustPlatform.buildRustPackage {
  pname = "psst";
  version = "0-unstable-2025-02-22";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = "psst";
    rev = "dd47c302147677433d70b398b1bcd7f1ade87638";
    hash = "sha256-EMjY8Tu+ssO30dD2qsvi3FAkt/UlXwM/ss2/FcyNNgI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0UllCmIe6oEl2Ecl4nqSk9ODdgso5ucX8T5nG3dVwbE=";

  # specify the subdirectory of the binary crate to build from the workspace
  buildAndTestSubdir = "psst-gui";

  env = {
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      atk
      cairo
      gdk-pixbuf
      glib
      gtk3
      pango
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      dbus
    ];

  patches = [
    # Use a fixed build time, hard-code upstream URL instead of trying to read `.git`
    ./make-build-reproducible.patch
  ];

  postInstall = ''
    install -Dm644 psst-gui/assets/logo_512.png -t $out/share/icons/hicolor/512x512/apps/psst.png
    install -Dm644 ${desktopItem}/share/applications/* -t $out/share/applications
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Spotify client with native GUI written in Rust, without Electron";
    homepage = "https://github.com/jpochyla/psst";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      vbrandl
      peterhoeg
    ];
    mainProgram = "psst-gui";
  };
}
