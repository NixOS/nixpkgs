{ stdenv, fetchurl, pythonPackages, file, less
, imagePreviewSupport ? true, w3m ? null}:

with stdenv.lib;

assert imagePreviewSupport -> w3m != null;

pythonPackages.buildPythonApplication rec {
  name = "ranger-1.8.1";

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = http://ranger.nongnu.org/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "http://ranger.nongnu.org/${name}.tar.gz";
    sha256 = "1d11qw0mr9aj22a7nhr6p2c3yzf359xbffmjsjblq44bjpwzjcql";
  };

  checkInputs = with pythonPackages; [ pytest ];
  propagatedBuildInputs = [ file ];

  checkPhase = ''
    py.test tests
  '';

  preConfigure = ''
    substituteInPlace ranger/data/scope.sh \
      --replace "/bin/echo" "echo"

    substituteInPlace ranger/__init__.py \
      --replace "DEFAULT_PAGER = 'less'" "DEFAULT_PAGER = '${stdenv.lib.getBin less}/bin/less'"

    for i in ranger/config/rc.conf doc/config/rc.conf ; do
      substituteInPlace $i --replace /usr/share $out/share
    done

    # give file previews out of the box
    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_script ~/.config/ranger/scope.sh" "set preview_script $out/share/doc/ranger/config/scope.sh"
  '' + optionalString imagePreviewSupport ''
    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m

    # give image previews out of the box when building with w3m
    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_images false" "set preview_images true" \
  '';

}
