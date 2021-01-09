{ cairo, cmake, fetchFromGitHub, libXdmcp, libpthreadstubs, libxcb, pcre, pkgconfig
, python3, stdenv, xcbproto, xcbutil, xcbutilcursor, xcbutilimage
, xcbutilrenderutil, xcbutilwm, xcbutilxrm, makeWrapper
, removeReferencesTo

# optional packages-- override the variables ending in 'Support' to enable or
# disable modules
, alsaSupport   ? true,  alsaLib       ? null
, githubSupport ? false, curl          ? null
, mpdSupport    ? false, mpd_clientlib ? null
, pulseSupport  ? false, libpulseaudio ? null
, iwSupport     ? false, wirelesstools ? null
, nlSupport     ? true,  libnl         ? null
, i3Support ? false, i3GapsSupport ? false, i3 ? null, i3-gaps ? null, jsoncpp ? null
}:

assert alsaSupport   -> alsaLib       != null;
assert githubSupport -> curl          != null;
assert mpdSupport    -> mpd_clientlib != null;
assert pulseSupport  -> libpulseaudio != null;

assert iwSupport     -> ! nlSupport && wirelesstools != null;
assert nlSupport     -> ! iwSupport && libnl         != null;

assert i3Support     -> ! i3GapsSupport && jsoncpp != null && i3      != null;
assert i3GapsSupport -> ! i3Support     && jsoncpp != null && i3-gaps != null;

stdenv.mkDerivation rec {
    pname = "polybar";
    version = "3.5.2";

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = version;
      sha256 = "1ir8fdnzrba9fkkjfvax5szx5h49lavwgl9pabjzrpbvif328g3x";
      fetchSubmodules = true;
    };

    meta = with stdenv.lib; {
      homepage = "https://polybar.github.io/";
      description = "A fast and easy-to-use tool for creating status bars";
      longDescription = ''
        Polybar aims to help users build beautiful and highly customizable
        status bars for their desktop environment, without the need of
        having a black belt in shell scripting.
      '';
      license = licenses.mit;
      maintainers = with maintainers; [ afldcr Br1ght0ne ];
      platforms = platforms.linux;
    };

    buildInputs = [
      cairo libXdmcp libpthreadstubs libxcb pcre python3 xcbproto xcbutil
      xcbutilcursor xcbutilimage xcbutilrenderutil xcbutilwm xcbutilxrm

      (if alsaSupport   then alsaLib       else null)
      (if githubSupport then curl          else null)
      (if mpdSupport    then mpd_clientlib else null)
      (if pulseSupport  then libpulseaudio else null)

      (if iwSupport     then wirelesstools else null)
      (if nlSupport     then libnl         else null)

      (if i3Support || i3GapsSupport then jsoncpp else null)
      (if i3Support then i3 else null)
      (if i3GapsSupport then i3-gaps else null)

      (if i3Support || i3GapsSupport then makeWrapper else null)
    ];

    postInstall = if (i3Support || i3GapsSupport) then ''
      wrapProgram $out/bin/polybar \
        --prefix PATH : "${if i3Support then i3 else i3-gaps}/bin"
    '' else "";

    nativeBuildInputs = [
      cmake pkgconfig removeReferencesTo
    ];

    postFixup = ''
        remove-references-to -t ${stdenv.cc} $out/bin/polybar
    '';
}
