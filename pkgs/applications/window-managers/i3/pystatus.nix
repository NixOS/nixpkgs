{ stdenv, fetchurl, libpulseaudio, python3Packages, extraLibs ? [] }:

python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  version = "3.34";
  pname = "i3pystatus";
  disabled = !python3Packages.isPy3k;

  src = fetchurl {
    url = "mirror://pypi/i/${pname}/${name}.tar.gz";
    sha256 = "1bpkkf9q4zqq7fh65zynbv26nq24rfznmw71jjvda7g8kjrwjdk5";
  };

  propagatedBuildInputs = with python3Packages; [ keyring colour netifaces praw psutil basiciw ] ++
    [ libpulseaudio ] ++ extraLibs;

  ldWrapperSuffix = "--suffix LD_LIBRARY_PATH : \"${libpulseaudio}/lib\"";
  makeWrapperArgs = [ ldWrapperSuffix ]; # libpulseaudio.so is loaded manually

  postInstall = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/${pname}-python-interpreter \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      ${ldWrapperSuffix}
  '';

  # no tests in tarball
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/enkore/i3pystatus;
    description = "A complete replacement for i3status";
    longDescription = ''
      i3pystatus is a growing collection of python scripts for status output compatible
      to i3status / i3bar of the i3 window manager.
    '';
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.igsha ];
  };
}

