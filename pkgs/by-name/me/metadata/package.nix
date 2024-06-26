{ stdenv, lib, fetchFromGitHub, pkg-config, ffmpeg, rustPlatform, asciidoc, libavutil }:
rustPlatform.buildRustPackage rec {
  pname = "metadata";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "zmwangx";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OFWdCV9Msy/mNaSubqoJi4tBiFqL7RuWWQluSnKe4fU=";
  };

  cargoHash = "sha256-F5jXS/W600nbQtu1FD4+DawrFsO+5lJjvAvTiFKT840=";

  # Build-time
  nativeBuildInputs = [ pkg-config asciidoc ];

  postBuildHook = "a2x --doctype manpage --format manpage man/metadata.1.adoc";
  postInstallHook = ''
    mkdir -p $out/share/man
    cp man/metadata.1 $out/share/man/
  '';

  # Run-time AND build-time
  BuildInputs = [ ffmpeg libavutil ];

  meta = {
    description = "Media file metadata for human consumption";
    longDescription = ''
      metadata is a media metadata parser and formatter designed for human consumption.
      Powered by FFmpeg.
    '';
    maintainers = with lib.maintainers; [ clevor ];
    license = lib.licenses.mit;
    homepage = "https://github.com/zmwangx/metadata";
    platforms = lib.platforms.linux;
    mainProgram = "metadata";
  };
}
