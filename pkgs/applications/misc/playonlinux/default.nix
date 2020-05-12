{ stdenv
, makeWrapper
, fetchurl
, cabextract
, gettext
, glxinfo
, gnupg
, icoutils
, imagemagick
, netcat-gnu
, p7zip
, python2
, unzip
, wget
, wine
, xdg-user-dirs
, xterm
, pkgs
, pkgsi686Linux
, which
, curl
, jq
, xorg
, libGL
}:

let
  version = "4.3.4";

  binpath = stdenv.lib.makeBinPath [ 
    cabextract
    python
    gettext
    glxinfo
    gnupg
    icoutils
    imagemagick
    netcat-gnu
    p7zip
    unzip
    wget
    wine
    xdg-user-dirs
    xterm
    which
    curl
    jq
  ];

  ld32 =
    if stdenv.hostPlatform.system == "x86_64-linux" then "${stdenv.cc}/nix-support/dynamic-linker-m32"
    else if stdenv.hostPlatform.system == "i686-linux" then "${stdenv.cc}/nix-support/dynamic-linker"
    else throw "Unsupported platform for PlayOnLinux: ${stdenv.hostPlatform.system}";
  ld64 = "${stdenv.cc}/nix-support/dynamic-linker";
  libs = pkgs: stdenv.lib.makeLibraryPath [ xorg.libX11 libGL ];

  python = python2.withPackages(ps: with ps; [
    wxPython
    setuptools
  ]);

in stdenv.mkDerivation {
  pname = "playonlinux";
  inherit version;

  src = fetchurl {
    url = "https://www.playonlinux.com/script_files/PlayOnLinux/${version}/PlayOnLinux_${version}.tar.gz";
    sha256 = "019dvb55zqrhlbx73p6913807ql866rm0j011ix5mkk2g79dzhqp";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ 
    xorg.libX11
    libGL
    python
  ];

  postPatch = ''
    patchShebangs python tests/python
    sed -i "s/ %F//g" etc/PlayOnLinux.desktop
  '';

  installPhase = ''
    install -d $out/share/playonlinux
    cp -r . $out/share/playonlinux/

    install -D -m644 etc/PlayOnLinux.desktop $out/share/applications/playonlinux.desktop

    makeWrapper $out/share/playonlinux/playonlinux $out/bin/playonlinux \
      --prefix PATH : ${binpath}

    bunzip2 $out/share/playonlinux/bin/check_dd_x86.bz2
    patchelf --set-interpreter $(cat ${ld32}) --set-rpath ${libs pkgsi686Linux} $out/share/playonlinux/bin/check_dd_x86
    ${if stdenv.hostPlatform.system == "x86_64-linux" then ''
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
    homepage = "https://www.playonlinux.com/";
    license = licenses.gpl3;
    maintainers = [ maintainers.a1russell ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
