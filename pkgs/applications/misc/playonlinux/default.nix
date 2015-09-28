{ stdenv
, makeWrapper
, fetchurl
, wxPython
, libXmu
, cabextract
, gettext
, glxinfo
, gnupg1compat
, icoutils
, imagemagick
, netcat
, p7zip
, python
, unzip
, wget
, wine
, xdg-user-dirs
, xterm
}:

stdenv.mkDerivation rec {
  name = "playonlinux-${version}";
  version = "4.2.9";

  src = fetchurl {
    url = "https://www.playonlinux.com/script_files/PlayOnLinux/${version}/PlayOnLinux_${version}.tar.gz";
    sha256 = "89bb0fd7cce8cf598ebf38cad716b8587eaca5b916d54386fb24b3ff66b48624";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs =
    [ wxPython
      libXmu
      cabextract
      gettext
      glxinfo
      gnupg1compat
      icoutils
      imagemagick
      netcat
      p7zip
      python
      unzip
      wget
      wine
      xdg-user-dirs
      xterm
    ];

  patchPhase = ''
    PYFILES="python/*.py python/lib/*.py tests/python/*.py"
    sed -i "s/env python[0-9.]*/python/" $PYFILES
    sed -i "s/ %F//g" etc/PlayOnLinux.desktop
  '';

  installPhase = ''
    install -d $out/share/playonlinux
    install -d $out/bin
    cp -r . $out/share/playonlinux/

    echo "#!${stdenv.shell}" > $out/bin/playonlinux
    echo "$prefix/share/playonlinux/playonlinux \"\$@\"" >> $out/bin/playonlinux
    chmod +x $out/bin/playonlinux

    install -D -m644 etc/PlayOnLinux.desktop $out/share/applications/playonlinux.desktop
  '';

  preFixupPhases = [ "preFixupPhase" ];

  preFixupPhase = ''
    for f in $out/bin/*; do
      wrapProgram $f \
        --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out") \
        --prefix PATH : \
    ${cabextract}/bin:\
    ${gettext}/bin:\
    ${glxinfo}/bin:\
    ${gnupg1compat}/bin:\
    ${icoutils}/bin:\
    ${imagemagick}/bin:\
    ${netcat}/bin:\
    ${p7zip}/bin:\
    ${python}/bin:\
    ${unzip}/bin:\
    ${wget}/bin:\
    ${wine}/bin:\
    ${xdg-user-dirs}/bin:\
    ${xterm}/bin

    done

    for f in $out/share/playonlinux/bin/*; do
      bunzip2 $f
    done
  '';

  postFixupPhases = [ "postFixupPhase" ];

  postFixupPhase = ''
    for f in $out/share/playonlinux/bin/*; do
      bzip2 $f
    done
  '';

  meta = with stdenv.lib; {
    description = "GUI for managing Windows programs under linux";
    homepage = https://www.playonlinux.com/;
    license = licenses.gpl3;
    maintainers = [ maintainers.a1russell ];
    platforms = platforms.linux;
  };
}
