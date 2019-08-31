{ stdenv, fetchurl, openjdk8, makeWrapper, autoPatchelfHook

, zlib, libzen, libmediainfo, curl, libmms, glib
}:

let
  curlWithGnuTls = curl.override { gnutlsSupport = true; sslSupport = false; };

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "filebot";
  version = "4.8.5";

  src = fetchurl {
    # This is a closed-source application, hence downloading a binary package.
    url = "https://get.filebot.net/filebot/FileBot_4.8.5/FileBot_4.8.5-portable.tar.xz";
    sha256 = "1c2a97rkv57cvy4arnmw9f3zdvxwb5zfvr9iqgpn9rkda00f2hy8";
  };

  unpackPhase = ''tar xvf $src'';

  nativeBuildInputs = [ makeWrapper autoPatchelfHook
                        # The following are lib dependencies for autoPatchelfHook to work.
                        stdenv.cc.cc.lib zlib libzen libmediainfo curlWithGnuTls libmms glib ];

  buildPhase = '''';
  installPhase = ''
    mkdir -p $out/opt
    # Since FileBot has depenencies on relative paths between files, all required files are copied to the same location as is.
    cp -r filebot.sh lib/ jar/ $out/opt/
    mkdir -p $out/bin
    # Filebot writes to $APP_DATA, which fails due to read-only filesystem. Using current user .local directory instead.
    substituteInPlace $out/opt/filebot.sh \
      --replace 'APP_DATA="$FILEBOT_HOME/data/$USER"' 'APP_DATA=''${XDG_DATA_HOME:-$HOME/.local/share}/filebot/data' \
      --replace '$FILEBOT_HOME/data/.license' '$APP_DATA/.license'
    wrapProgram $out/opt/filebot.sh \
      --prefix PATH : ${stdenv.lib.makeBinPath [ openjdk8 ]}
    # Expose the binary in bin to make runnable.
    ln -s $out/opt/filebot.sh $out/bin/filebot
  '';

  patchPhase = '''';

  meta = with stdenv.lib; {
    description = "The ultimate TV and Movie Renamer";
    longDescription = ''
      FileBot is the ultimate tool for organizing and renaming your Movies, TV
      Shows and Anime as well as fetching subtitles and artwork. It's smart and
      just works.
    '';
    homepage = https://filebot.net;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ gleber ];
    platforms = platforms.linux;
  };
}
