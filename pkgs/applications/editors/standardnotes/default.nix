{ stdenv, appimage-run, fetchurl }:

let
  version = "3.0.6";

  plat = {
    "i386-linux" = "i386";
    "x86_64-linux" = "x86_64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    "i386-linux" = "0czhlbacjks9x8y2w46nzlvk595psqhqw0vl0bvsq7sz768dk0ni";
    "x86_64-linux" = "0haji9h8rrm9yvqdv6i2y6xdd0yhsssjjj83hmf6cb868lwyigsf";
  }.${stdenv.hostPlatform.system};
in

stdenv.mkDerivation rec {
  name = "standardnotes-${version}";

  src = fetchurl {
    url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}-${plat}.AppImage";
    inherit sha256;
  };

  buildInputs = [ appimage-run ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/standardNotes.AppImage
    echo "#!${stdenv.shell}" > $out/bin/standardnotes
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
