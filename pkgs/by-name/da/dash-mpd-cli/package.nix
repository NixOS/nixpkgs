{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "dash-mpd-cli";
  version = "0.2.24";

  src = fetchFromGitHub {
    owner = "emarsden";
    repo = "dash-mpd-cli";
    tag = "v${version}";
    hash = "sha256-Q4zzKdp8GROL8vHi8XETErqufSqgZH/zf/mqEH2lIzE=";
  };

  cargoHash = "sha256-R54Np08hYpDoidsHr3rmhpX/QZZkZHGcCSoKk6nw9R8=";

  nativeBuildInputs = [ protobuf ];

  # The tests depend on network access.
  doCheck = false;

  meta = {
    description = "Download media content from a DASH-MPEG or DASH-WebM MPD manifest";
    longDescription = ''
      A commandline application for downloading media content from a DASH MPD
      file, as used for on-demand replay of TV content and video streaming
      services.
    '';
    homepage = "https://emarsden.github.io/dash-mpd-cli/";
    downloadPage = "https://github.com/emarsden/dash-mpd-cli/releases";
    changelog = "https://github.com/emarsden/dash-mpd-cli/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ al3xtjames ];
    mainProgram = "dash-mpd-cli";
  };
}
