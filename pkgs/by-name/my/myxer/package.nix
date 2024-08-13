{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook3
, libpulseaudio
, glib
, pango
, gtk3
}:

rustPlatform.buildRustPackage rec {
  pname = "myxer";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Aurailus";
    repo = "myxer";
    rev = version;
    hash = "sha256-c5SHjnhWLp0jMdmDlupMTA0hWphub5DFY1vOI6NW8E0=";
  };

  cargoHash = "sha256-IH+SLIHO/wu+przH+mgOEnH9m+iAE5s/BJhh0UUHR/0=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 ];

  buildInputs = [ libpulseaudio glib pango gtk3 ];

  postInstall = ''
    install -Dm644 Myxer.desktop $out/share/applications/Myxer.desktop
  '';

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "A modern Volume Mixer for PulseAudio";
    homepage = "https://github.com/Aurailus/Myxer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ erin rster2002 ];
    mainProgram = "myxer";
    platforms = platforms.linux;
  };
}
