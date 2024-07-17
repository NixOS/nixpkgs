{
  lib,
  fetchFromGitHub,
  pkg-config,
  ffmpeg_7,
  rustPlatform,
  glib,
  installShellFiles,
  asciidoc,
}:
rustPlatform.buildRustPackage rec {
  pname = "metadata";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "zmwangx";
    repo = "metadata";
    rev = "v${version}";
    hash = "sha256-OFWdCV9Msy/mNaSubqoJi4tBiFqL7RuWWQluSnKe4fU=";
  };

  cargoHash = "sha256-F5jXS/W600nbQtu1FD4+DawrFsO+5lJjvAvTiFKT840=";

  nativeBuildInputs = [
    pkg-config
    asciidoc
    installShellFiles
    rustPlatform.bindgenHook
  ];

  postBuild = ''
    a2x --doctype manpage --format manpage man/metadata.1.adoc
  '';
  postInstall = ''
    installManPage man/metadata.1
  '';

  buildInputs = [
    ffmpeg_7
    glib
  ];

  env.FFMPEG_DIR = ffmpeg_7.dev;

  meta = {
    description = "Media metadata parser and formatter designed for human consumption, powered by FFmpeg";
    maintainers = with lib.maintainers; [ clevor ];
    license = lib.licenses.mit;
    homepage = "https://github.com/zmwangx/metadata";
    mainProgram = "metadata";
  };
}
