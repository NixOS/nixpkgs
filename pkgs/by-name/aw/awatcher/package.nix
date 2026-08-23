{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  libxkbcommon,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "awatcher";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "2e3s";
    repo = "awatcher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZC2BfWoBa2qvLkROG30FTIVTbS64VO41haJLHtLzjT0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    libxkbcommon
  ];
  doCheck = false;

  cargoHash = "sha256-1QLXMqqEBAu6ZfdMNZKkynFkoqXEUgSG9QNICd9/6VY=";

  meta = {
    description = "Activity and idle watchers";
    longDescription = ''
      Awatcher is a window activity and idle watcher with an optional tray and UI for statistics. The goal is to compensate
      the fragmentation of desktop environments on Linux by supporting all reportable environments, to add more
      flexibility to reports with filters, and to have better UX with the distribution by a single executable.
    '';
    downloadPage = "https://github.com/2e3s/awatcher/releases";
    homepage = "https://github.com/2e3s/awatcher";
    license = lib.licenses.mpl20;
    mainProgram = "awatcher";
    maintainers = [ lib.maintainers.aikooo7 ];
    platforms = lib.platforms.linux;
  };
})
