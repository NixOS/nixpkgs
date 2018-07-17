{ cairo, cmake, fetchgit, libXdmcp, libpthreadstubs, libxcb, pcre, pkgconfig
, python2 , stdenv, xcbproto, xcbutil, xcbutilimage, xcbutilrenderutil
, xcbutilwm, xcbutilxrm, fetchpatch, makeWrapper

# optional packages-- override the variables ending in 'Support' to enable or
# disable modules
, alsaSupport   ? true,  alsaLib       ? null
, paSupport     ? true,  libpulseaudio ? null
, iwSupport     ? true,  wirelesstools ? null
, githubSupport ? false, curl          ? null
, mpdSupport    ? false, mpd_clientlib ? null
, i3Support ? false, i3GapsSupport ? false, i3 ? null, i3-gaps ? null, jsoncpp ? null
}:

assert alsaSupport   -> alsaLib       != null;
assert paSupport     -> libpulseaudio != null;
assert githubSupport -> curl          != null;
assert iwSupport     -> wirelesstools != null;
assert mpdSupport    -> mpd_clientlib != null;

assert i3Support     -> ! i3GapsSupport && jsoncpp != null && i3      != null;
assert i3GapsSupport -> ! i3Support     && jsoncpp != null && i3-gaps != null;

stdenv.mkDerivation rec {
    name = "polybar-git-${version}";
    version = "2018-06-23";
    src = fetchgit {
      url = "https://github.com/jaagr/polybar";
      rev = "028b1413ef9490cdcb21348ea0ca704828ef538e";
      sha256 = "01mqwnlq7d9c503c5cnc19hl7hvk03fmih1wis7zljxdiz5hb82d";
    };

    meta = with stdenv.lib; {
      description = "A fast and easy-to-use tool for creating status bars.";
      longDescription = ''
        Polybar aims to help users build beautiful and highly customizable
        status bars for their desktop environment, without the need of
        having a black belt in shell scripting.
      '';
      license = licenses.mit;
      maintainers = [ maintainers.rembo10 ];
      platforms = platforms.unix;
    };

    buildInputs = [
      cairo libXdmcp libpthreadstubs libxcb pcre python2 xcbproto xcbutil
      xcbutilimage xcbutilrenderutil xcbutilwm xcbutilxrm

      (if alsaSupport   then alsaLib       else null)
      (if paSupport     then libpulseaudio else null)
      (if githubSupport then curl          else null)
      (if iwSupport     then wirelesstools else null)
      (if mpdSupport    then mpd_clientlib else null)

      (if i3Support || i3GapsSupport then jsoncpp else null)
      (if i3Support then i3 else null)
      (if i3GapsSupport then i3-gaps else null)

      (if i3Support || i3GapsSupport then makeWrapper else null)
    ];

    fixupPhase = if (i3Support || i3GapsSupport) then ''
    wrapProgram $out/bin/polybar \
      --prefix PATH : "${if i3Support then i3 else i3-gaps}/bin"
  '' else null;

    nativeBuildInputs = [
      cmake pkgconfig
    ];
}
