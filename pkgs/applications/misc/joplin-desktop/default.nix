{ stdenv, appimage-run, fetchurl }:

let
  version = "1.0.120";
  sha256 = "0j32rg6hm5dirdcibhfhrclnx7vm37fbm4iwkzzinqhzj4jfgbfm";
in
  stdenv.mkDerivation rec {
  name = "joplin-${version}";

  src = fetchurl {
    url = "https://github.com/laurent22/joplin/releases/download/v${version}/Joplin-${version}-x86_64.AppImage";
    inherit sha256;
  };

  buildInputs = [ appimage-run ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/joplin.AppImage
    echo "#!/bin/sh" > $out/bin/joplin-desktop
    echo "${appimage-run}/bin/appimage-run $out/share/joplin.AppImage" >> $out/bin/joplin-desktop
    chmod +x $out/bin/joplin-desktop $out/share/joplin.AppImage
  '';

  meta = with stdenv.lib; {
    description = "An open source note taking and to-do application with synchronisation capabilities";
    longDescription = ''
      Joplin is a free, open source note taking and to-do application, which can
      handle a large number of notes organised into notebooks. The notes are
      searchable, can be copied, tagged and modified either from the
      applications directly or from your own text editor. The notes are in
      Markdown format.
    '';
    homepage = https://joplin.cozic.net/;
    license = licenses.mit;
    maintainers = with maintainers; [ rafaelgg raquelgb ];
    platforms = [ "x86_64-linux" ];
  };
}
