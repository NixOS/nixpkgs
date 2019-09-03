{ stdenv, appimage-run, fetchurl, runtimeShell }:

let
  version = "3.0.15";

  plat = {
    "i386-linux" = "i386";
    "x86_64-linux" = "x86_64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    "i386-linux" = "0v2nsis6vb1lnhmjd28vrfxqwwpycv02j0nvjlfzcgj4b3400j7a";
    "x86_64-linux" = "130n586cw0836zsbwqcz3pp3h0d4ny74ngqs4k4cvfb92556r7xh";
  }.${stdenv.hostPlatform.system};
in

stdenv.mkDerivation rec {
  pname = "standardnotes";
  inherit version;

  src = fetchurl {
    url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}-${plat}.AppImage";
    inherit sha256;
  };

  buildInputs = [ appimage-run ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/standardNotes.AppImage
    echo "#!${runtimeShell}" > $out/bin/standardnotes
    echo "${appimage-run}/bin/appimage-run $out/share/standardNotes.AppImage" >> $out/bin/standardnotes
    chmod +x $out/bin/standardnotes $out/share/standardNotes.AppImage
  '';

  meta = with stdenv.lib; {
    description = "A simple and private notes app";
    longDescription = ''
      Standard Notes is a private notes app that features unmatched simplicity,
      end-to-end encryption, powerful extensions, and open-source applications.
    '';
    homepage = https://standardnotes.org;
    license = licenses.agpl3;
    maintainers = with maintainers; [ mgregoire ];
    platforms = [ "i386-linux" "x86_64-linux" ];
  };
}
