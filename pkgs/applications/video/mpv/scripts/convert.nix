{ stdenv, fetchgit, lib
, yad, mkvtoolnix-cli, libnotify }:

stdenv.mkDerivation {
  name = "mpv-convert-script-2016-03-18.lua";
  src = fetchgit {
    url = "https://gist.github.com/Zehkul/25ea7ae77b30af959be0";
    rev = "f95cee43e390e843a47e8ec9d1711a12a8cd343d";
    sha256 = "13m7l4sy2r8jv2sfrb3vvqvnim4a9ilnv28q5drlg09v298z3mck";
  };

  patches = [ ./convert.patch ];

  postPatch =
    let
      t = k: v: '' 'local ${k} = "${v}"' '';
      subs = var: orig: repl: "--replace " + t var orig + t var repl;
    in ''
      substituteInPlace convert_script.lua \
        ${subs "NOTIFY_CMD" "notify-send" "${libnotify}/bin/notify-send"} \
        ${subs "YAD_CMD" "yad" "${yad}/bin/yad"} \
        ${subs "MKVMERGE_CMD" "mkvmerge" "${mkvtoolnix-cli}/bin/mkvmerge"}
  '';

  dontBuild = true;
  installPhase = ''
    cp convert_script.lua $out
  '';

  meta = {
    description = "Convert parts of a video while you are watching it in mpv";
    homepage = https://gist.github.com/Zehkul/25ea7ae77b30af959be0;
    maintainers = [ lib.maintainers.Profpatsch ];
    longDescription = ''
      When this script is loaded into mpv, you can hit Alt+W to mark the beginning
      and Alt+W again to mark the end of the clip. Then a settings window opens.
    '';
  };
}

