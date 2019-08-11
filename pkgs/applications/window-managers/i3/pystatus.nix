{ stdenv, fetchFromGitHub, libpulseaudio, python3Packages, extraLibs ? [] }:

python3Packages.buildPythonApplication rec {
  # i3pystatus moved to rolling release:
  # https://github.com/enkore/i3pystatus/issues/584
  version = "unstable-2019-06-10";
  pname = "i3pystatus";

  src = fetchFromGitHub
  {
    owner = "enkore";
    repo = "i3pystatus";
    rev = "56ce08d0ff8d5d64950d6b588ebede35a95e0ce2";
    sha256 = "12938860jbcly1xwhd71jvy2dff28pwv9kqh6mab1859148bzmcg";
  };

  propagatedBuildInputs = with python3Packages; [ keyring colour netifaces psutil basiciw ] ++
    [ libpulseaudio ] ++ extraLibs;

  libpulseaudioPath = stdenv.lib.makeLibraryPath [ libpulseaudio ];
  ldWrapperSuffix = "--suffix LD_LIBRARY_PATH : \"${libpulseaudioPath}\"";
  # LC_TIME != C results in locale.Error: unsupported locale setting
  makeWrapperArgs = [ "--set LC_TIME C" ldWrapperSuffix ]; # libpulseaudio.so is loaded manually

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
