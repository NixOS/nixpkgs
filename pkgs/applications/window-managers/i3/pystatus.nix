{ lib
, fetchFromGitHub
, libpulseaudio
, libnotify
, gobject-introspection
, python3Packages
, extraLibs ? [] }:

python3Packages.buildPythonApplication rec {
  # i3pystatus moved to rolling release:
  # https://github.com/enkore/i3pystatus/issues/584
  version = "unstable-2020-06-12";
  pname = "i3pystatus";

  src = fetchFromGitHub {
    owner = "enkore";
    repo = "i3pystatus";
    rev = "dad5eb0c5c8a2ecd20c37ade4732586c6e53f44b";
    sha256 = "18ygvkl92yr69kxsym57k1mc90asdxpz4b943i61qr0s4fc5n4mq";
  };

  nativeBuildInputs = [
    gobject-introspection
  ];

  buildInputs = [ libpulseaudio libnotify ];

  propagatedBuildInputs = with python3Packages; [
    keyring colour netifaces psutil basiciw pygobject3
  ] ++ extraLibs;

  makeWrapperArgs = [
    # LC_TIME != C results in locale.Error: unsupported locale setting
    "--set" "LC_TIME" "C"
    "--suffix" "LD_LIBRARY_PATH" ":" "${lib.makeLibraryPath [ libpulseaudio ]}"
  ];

  postPatch = ''
    makeWrapperArgs+=(--set GI_TYPELIB_PATH "$GI_TYPELIB_PATH")
  '';

  postInstall = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/${pname}-python-interpreter \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      ''${makeWrapperArgs[@]}
  '';

  # no tests in tarball
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/enkore/i3pystatus";
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
