{
  stdenv,
  gst-thumbnailers,
  shared-mime-info,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-thumbnailers-test";
  inherit (gst-thumbnailers) version src;

  sourceRoot = "${finalAttrs.src.name}/tests";

  nativeBuildInputs = [
    # fontconfig tries to write to `~/.cache/fontconfig`
    writableTmpDirAsHomeHook
  ];

  # Fix incorrectly detected MIME types
  preBuild = ''
    export XDG_DATA_DIRS=${shared-mime-info}/share:$XDG_DATA_DIRS
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p $out

    for file in *.{flac,mp3,mkv,webm}; do
      case "$file" in
        *.flac|*.mp3) thumbnailer=gst-audio-thumbnailer ;;
        *.mkv|*.webm) thumbnailer=gst-video-thumbnailer ;;
      esac

      for size in 128 256 512 1024; do
        input="file://$(realpath "$file")"
        output="$out/$(basename "$file")-$size.png"

        ${gst-thumbnailers}/bin/$thumbnailer -i "$input" -o "$output" -s $size
        file -E "$output"
      done
    done

    runHook postBuild
  '';
})
