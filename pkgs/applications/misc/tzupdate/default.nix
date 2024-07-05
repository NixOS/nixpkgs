{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tzupdate";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = "tzupdate";
    rev = version;
    hash = "sha256-eod4yFzX7pATNQmG7jU+r9mnC9nprJ55ufMXpKjw/YI=";
  };

  cargoHash = "sha256-5+lp5xlwJxFDqzVxptJPX7z0iLoMkgdwHxvRVIXHF7Y=";

  meta = with lib; {
    description = "Set the system timezone based on IP geolocation";
    homepage = "https://github.com/cdown/tzupdate";
    license = licenses.mit;
    maintainers = with maintainers; [ camillemndn ];
    platforms = platforms.linux;
    mainProgram = "tzupdate";
  };
}
