{ stdenv
, makeWrapper
, fetchurl
, cabextract
, gettext
, glxinfo
, gnupg1compat
, icoutils
, imagemagick
, netcat
, p7zip
, python2Packages
, unzip
, wget
, wine
, xdg-user-dirs
, xterm
, pkgs
, pkgsi686Linux
, which
, curl
}:

assert stdenv.isLinux;

let
  version = "4.2.10";

  binpath = stdenv.lib.makeBinPath
    [ cabextract
      python2Packages.python
      gettext
      glxinfo
      gnupg1compat
      icoutils
      imagemagick
      netcat
      p7zip
      unzip
      wget
      wine
      xdg-user-dirs
      xterm
      which
      curl
    ];

  ld32 =
    if stdenv.system == "x86_64-linux" then "${stdenv.cc}/nix-support/dynamic-linker-m32"
    else if stdenv.system == "i686-linux" then "${stdenv.cc}/nix-support/dynamic-linker"
    else abort "Unsupported platform for PlayOnLinux: ${stdenv.system}";
  ld64 = "${stdenv.cc}/nix-support/dynamic-linker";
  libs = pkgs: stdenv.lib.makeLibraryPath [ pkgs.xlibs.libX11 ];

in stdenv.mkDerivation {
  name = "playonlinux-${version}";

  src = fetchurl {
    url = "https://www.playonlinux.com/script_files/PlayOnLinux/${version}/PlayOnLinux_${version}.tar.gz";
    sha256 = "0ws94hgxajaww450q8ivrp28ypv39mashs29ak41faxf29cr097m";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs =
    [ python2Packages.python
      python2Packages.wxPython
      python2Packages.setuptools
    ];

  patchPhase = ''
    patchShebangs python tests/python
    sed -i "s/ %F//g" etc/PlayOnLinux.desktop
  '';

  installPhase = ''
    install -d $out/share/playonlinux
    cp -r . $out/share/playonlinux/

    install -D -m644 etc/PlayOnLinux.desktop $out/share/applications/playonlinux.desktop

    makeWrapper $out/share/playonlinux/playonlinux $out/bin/playonlinux \
      --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out") \
      --prefix PATH : ${binpath}

    bunzip2 $out/share/playonlinux/bin/check_dd_x86.bz2
    patchelf --set-interpreter $(cat ${ld32}) --set-rpath ${libs pkgsi686Linux} $out/share/playonlinux/bin/check_dd_x86
    ${if stdenv.system == "x86_64-linux" then ''
      bunzip2 $out/share/playonlinux/bin/check_dd_amd64.bz2
      patchelf --set-interpreter $(cat ${ld64}) --set-rpath ${libs pkgs} $out/share/playonlinux/bin/check_dd_amd64
    '' else ''
      rm $out/share/playonlinux/bin/check_dd_amd64.bz2
    ''}
    for f in $out/share/playonlinux/bin/*; do
      bzip2 $f
    done
  '';

  meta = with stdenv.lib; {
    description = "GUI for managing Windows programs under linux";
    homepage = https://www.playonlinux.com/;
    license = licenses.gpl3;
    maintainers = [ maintainers.a1russell ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
