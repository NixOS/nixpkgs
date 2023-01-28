{ lib, stdenv, fetchurl, openjdk17, makeWrapper, autoPatchelfHook
, zlib, libzen, libmediainfo, curlWithGnuTls, libmms, glib
}:

stdenv.mkDerivation rec {
  pname = "filebot";
  version = "4.9.6";

  src = fetchurl {
    url = "https://web.archive.org/web/20220305095926/https://get.filebot.net/filebot/FileBot_${version}/FileBot_${version}-portable.tar.xz";
    sha256 = "sha256-3j0WmmamE9KUNwjOVZvrdFH5dS/9FHSdbLfcAsOzQOo=";
  };

  unpackPhase = "tar xvf $src";

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];

  buildInputs = [ zlib libzen libmediainfo curlWithGnuTls libmms glib ];

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/opt $out/bin
    # Since FileBot has dependencies on relative paths between files, all required files are copied to the same location as is.
    cp -r filebot.sh lib/ jar/ $out/opt/
    # Filebot writes to $APP_DATA, which fails due to read-only filesystem. Using current user .local directory instead.
    substituteInPlace $out/opt/filebot.sh \
      --replace 'APP_DATA="$FILEBOT_HOME/data/$(id -u)"' 'APP_DATA=''${XDG_DATA_HOME:-$HOME/.local/share}/filebot/data' \
      --replace '$FILEBOT_HOME/data/.license' '$APP_DATA/.license'
    wrapProgram $out/opt/filebot.sh \
      --prefix PATH : ${lib.makeBinPath [ openjdk17 ]}
    # Expose the binary in bin to make runnable.
    ln -s $out/opt/filebot.sh $out/bin/filebot
  '';

  meta = with lib; {
    description = "The ultimate TV and Movie Renamer";
    longDescription = ''
      FileBot is the ultimate tool for organizing and renaming your Movies, TV
      Shows and Anime as well as fetching subtitles and artwork. It's smart and
      just works.
    '';
    homepage = "https://filebot.net";
    changelog = "https://www.filebot.net/forums/viewforum.php?f=7";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ gleber felschr ];
    platforms = platforms.linux;
  };
}
