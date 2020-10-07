{ lib, rustPlatform, fetchFromGitHub, pkgconfig, dbus
, withPulseaudio ? true, libpulseaudio ? null
, withNotmuch ? false, notmuch ? null }:

assert withPulseaudio -> libpulseaudio != null;
assert withNotmuch -> notmuch != null;

with lib;

rustPlatform.buildRustPackage rec {
  pname = "i3status-rust";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "v${version}";
    sha256 = "11qhzjml04njhfa033v98m4yd522zj91s6ffvrm0m6sk7m0wyjsc";
  };

  cargoSha256 = "0jmmxld4rsjj6p5nazi3d8j1hh7r34q6kyfqq4wv0sjc77gcpaxd";

  cargoBuildFlags = [
    "--no-default-features"
    "--features" (escapeShellArg (concatStringsSep " " (
      optional withPulseaudio "pulseaudio" ++
      optional withNotmuch "notmuch"
    )))
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus ]
    ++ optional withPulseaudio libpulseaudio
    ++ optional withNotmuch notmuch;

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = "https://github.com/greshake/i3status-rust";
    license = licenses.gpl3;
    maintainers = with maintainers; [ backuitist globin ma27 ];
    platforms = platforms.linux;
  };
}
