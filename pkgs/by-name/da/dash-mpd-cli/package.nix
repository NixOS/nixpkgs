{
  lib,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  protobuf,
  ffmpeg,
  libxslt,
  shaka-packager,
  nix-update-script,
  runCommand,
}:

let
  # dash-mpd-cli looks for a binary named `shaka-packager`, while
  # shaka-packager provides `packager`.
  shaka-packager-wrapped = runCommand "shaka-packager-wrapped" { } ''
    mkdir -p $out/bin
    ln -s ${lib.getExe shaka-packager} $out/bin/shaka-packager
  '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dash-mpd-cli";
  version = "0.2.27";

  src = fetchFromGitHub {
    owner = "emarsden";
    repo = "dash-mpd-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s8Wu9DOjfQDm4OONtocJCiklEZ775tFyzKIbKm3WfDc=";
  };

  patches = [
    ./use-shaka-by-default.patch
  ];

  cargoHash = "sha256-ycHKgQFgl8THoXT+3ccV8AC56VudHzObyTCu333MmT4=";

  nativeBuildInputs = [
    makeWrapper
    protobuf
  ];

  # The tests depend on network access.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/dash-mpd-cli \
      --prefix PATH : ${
        lib.makeBinPath [
          (lib.getBin ffmpeg)
          (lib.getBin libxslt)
          shaka-packager-wrapped
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

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
})
