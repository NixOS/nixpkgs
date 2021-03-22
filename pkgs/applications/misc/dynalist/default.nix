{ stdenv
, fetchurl
, makeWrapper
, electron_4
, openssl
}:

let
  electron = electron_4;

in

stdenv.mkDerivation rec {
  pname = "dynalist";
  version = "1.0.5";

  src = fetchurl {
      url = "https://dynalist.io/standalone/download?file=dynalist.tar.gz";
      sha256 = "0gn0700w7wzqbsq395rsc21qh2lw7zd83w3anh3h7y6w75987kk2";
    };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = false;
  dontConfigure = true;
  dontBuild = true;

  installPhase = let
    runtimeLibs = [
      openssl.out
      stdenv.cc.cc
    ];
  in ''
    mkdir -p $out/bin $out/share/${pname}

    # Applications files.
    cp -a resources $out/share/${pname}
    cp -a locales $out/share/${pname}

    # Wrap the application with Electron.
    makeWrapper "${electron}/bin/electron" "$out/bin/${pname}" \
      --add-flags "$out/share/${pname}/resources/app.asar" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath runtimeLibs}"
  '';

  passthru.updateScript = ./update.sh;

  meta = with stdenv.lib; {
    description  = "Outlining and organization application";
    homepage     = "https://dynalist.io";
    downloadPage = "https://dynalist.io/download";
    maintainers  = with maintainers; [ pmyjavec ];
    license      = licenses.unfree;
    platforms    = [ "x86_64-linux" ];
  };

}
