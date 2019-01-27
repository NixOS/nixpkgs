{ stdenv, appimageTools, fetchurl }:

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
in appimageTools.wrapType2 rec {
  name = "standardnotes-${version}";

  src = fetchurl {
    url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}-${plat}.AppImage";
    inherit sha256;
  };

  extraInstallCommands = "ln -s $out/bin/${name} $out/bin/standardnotes";

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
