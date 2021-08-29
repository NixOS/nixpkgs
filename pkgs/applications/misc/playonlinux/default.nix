{ lib, stdenv
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
, python3
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
, steam-run-native
# needed for avoiding crash on file selector
, gsettings-desktop-schemas
}:

let
  version = "4.4";

  binpath = lib.makeBinPath [
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
  libs = pkgs: lib.makeLibraryPath [ xorg.libX11 libGL ];

  python = python3.withPackages(ps: with ps; [
    wxPython_4_1
    setuptools
    natsort
  ]);

in stdenv.mkDerivation {
  pname = "playonlinux";
  inherit version;

  src = fetchurl {
    url = "https://www.playonlinux.com/script_files/PlayOnLinux/${version}/PlayOnLinux_${version}.tar.gz";
    sha256 = "0n40927c8cnjackfns68zwl7h4d7dvhf7cyqdkazzwwx4k2xxvma";
  };

  patches = [
    ./0001-fix-locale.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    makeFlagsArray+=(PYTHON="python -m py_compile")
  '';

  buildInputs = [
    xorg.libX11
    libGL
    python
  ];

  postPatch = ''
    substituteAllInPlace python/lib/lng.py
    patchShebangs python tests/python
    sed -i "s/ %F//g" etc/PlayOnLinux.desktop
  '';

  installPhase = ''
    install -d $out/share/playonlinux
    cp -r . $out/share/playonlinux/

    install -D -m644 etc/PlayOnLinux.desktop $out/share/applications/playonlinux.desktop

    makeWrapper $out/share/playonlinux/playonlinux{,-wrapper} \
      --prefix PATH : ${binpath} \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/GConf
    # steam-run is needed to run the downloaded wine executables
    mkdir -p $out/bin
    cat > $out/bin/playonlinux <<EOF
    #!${stdenv.shell} -e
    exec ${steam-run-native}/bin/steam-run $out/share/playonlinux/playonlinux-wrapper "\$@"
    EOF
    chmod a+x $out/bin/playonlinux

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

  meta = with lib; {
    description = "GUI for managing Windows programs under linux";
    homepage = "https://www.playonlinux.com/";
    license = licenses.gpl3;
    maintainers = [ maintainers.pasqui23 ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
