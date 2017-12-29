{ cairo, cmake, fetchgit, libXdmcp, libpthreadstubs, libxcb, pcre, pkgconfig
, python2 , stdenv, xcbproto, xcbutil, xcbutilimage, xcbutilrenderutil
, xcbutilwm, xcbutilxrm, fetchpatch

# optional packages-- override the variables ending in 'Support' to enable or
# disable modules
, alsaSupport   ? true,  alsaLib       ? null
, iwSupport     ? true,  wirelesstools ? null
, githubSupport ? false, curl          ? null
, mpdSupport    ? false, mpd_clientlib ? null
, i3Support ? false, i3GapsSupport ? false, i3 ? null, i3-gaps ? null, jsoncpp ? null
}:

assert alsaSupport   -> alsaLib       != null;
assert githubSupport -> curl          != null;
assert iwSupport     -> wirelesstools != null;
assert mpdSupport    -> mpd_clientlib != null;

assert i3Support     -> ! i3GapsSupport && jsoncpp != null && i3      != null;
assert i3GapsSupport -> ! i3Support     && jsoncpp != null && i3-gaps != null;

stdenv.mkDerivation rec {
    name = "polybar-${version}";
    version = "3.0.5";
    src = fetchgit {
      url = "https://github.com/jaagr/polybar";
      rev = "4e2e2a7a5e0fe81669031ade0f60e1d379b6516d";
      sha256 = "1iiks9q13pbkgbjhdns18a5zgr6d40ydcm4qn168m73fs6ivf1vn";
    };

    meta = with stdenv.lib; {
      description = "A fast and easy-to-use tool for creatin status bars.";
      longDescription = ''
        Polybar aims to help users build beautiful and highly customizable
        status bars for their desktop environment, without the need of
        having a black belt in shell scripting.
      '';
      license = licenses.mit;
      maintainers = [ maintainers.afldcr ];
      platforms = platforms.unix;
    };
    # This patch should be removed with next stable release.
    patches = [
      (fetchpatch {
        name = "polybar-remove-curlbuild.patch";
        url = "https://github.com/jaagr/polybar/commit/d35abc7620c8f06618b4708d9a969dfa2f309e96.patch";
        sha256 = "14xr65vsjvd51hzg9linj09w0nnixgn26dh9lqxy25bxachcyzxy";
      })
    ];

    buildInputs = [
      cairo libXdmcp libpthreadstubs libxcb pcre python2 xcbproto xcbutil
      xcbutilimage xcbutilrenderutil xcbutilwm xcbutilxrm

      (if alsaSupport   then alsaLib       else null)
      (if githubSupport then curl          else null)
      (if iwSupport     then wirelesstools else null)
      (if mpdSupport    then mpd_clientlib else null)

      (if i3Support || i3GapsSupport then jsoncpp else null)
      (if i3Support then i3 else null)
      (if i3GapsSupport then i3-gaps else null)
    ];

    nativeBuildInputs = [
      cmake pkgconfig
    ];
}
