{
  stdenv,
  fetchFromGitHub,
  pkgs,
  lib,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "dvrescue";
  version = "24.07";

  src = fetchFromGitHub {
    owner = "mipops";
    repo = "dvrescue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cR7az1F/K+/88oWKI0ns/jkOzIg6JGXzzO0IB6ZK5HM=";
  };

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    pkg-config
    libmediainfo
    libavc1394
    libiec61883
    zlib
    makeWrapper
  ];

  buildInputs = with pkgs; [
    libzen
  ];

  postPatch = ''
    # dvplay otherwise hardcodes a path to the liberation font on Linux
    font_path="${pkgs.liberation_ttf}/share/fonts/truetype/LiberationSans-Regular.ttf"
    if [ ! -e "$font_path" ]; then
       echo >&2 "ERROR: A file was expected to exist at:"
       echo >&2 "$font_path"
       echo >&2 "On Linux, dvplay will fail at runtime if this file does not exist."
       echo >&2 "If this file moves, the dvrescue package must be updated."
       exit 1
    fi
    substituteInPlace "tools/dvplay" \
      --replace-fail /usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf "$font_path"
  '';

  preAutoreconf = ''
    cd "./Project/GNU/CLI"
  '';

  postFixup = ''
    for program in dvplay; do
      wrapProgram "$out/bin/$program" \
        --set PATH ${
          lib.makeBinPath [
            pkgs.which
            pkgs.coreutils
            pkgs.mediainfo
            pkgs.ffmpeg
            pkgs.ncurses # tput
            pkgs.gnugrep
            pkgs.gnused
          ]
        }
    done
  '';

  passthru = {
    updateScript = nix-update-script;
  };

  meta = {
    description = "Archivist-made software that supports data migration from DV tapes into digital files suitable for long-term preservation";
    longDescription = ''
      DVRescue is cross-platform archivist made and designed software for the
      advanced support of data migration from DV tapes into digital files suitable
      for long-term preservation. It facilitates both high-quality digital capture
      via FireWire as well as provides deep levels of context and analysis of
      embedded DV metadata that can be used, among other things, to create files with
      highly reduced error rate via amalgamating across multiple captures.
    '';
    homepage = "https://mediaarea.net/DVRescue";
    license = lib.licenses.bsd3;
    changelog = "https://github.com/mipops/dvrescue/blob/v${finalAttrs.version}/History.txt";
    maintainers = with lib.maintainers; [
      acuteaangle
    ];
    mainProgram = "dvrescue";
  };
})
