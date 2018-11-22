{ stdenv, fetchurl, file, lib, libX11, libXScrnSaver,
  gcc-unwrapped, libGL, qt5, SDL, libpulseaudio,
  libXrandr, libXext, libXcursor, libXinerama, libXi,
  ffmpeg-full, curl, sqlite, openssl_1_1_0,
  libuuid, openh264, libv4l, libxkbfile, libXv, zlib, libXmu,
  libXtst, libXdamage, pam, patchelfUnstable, libXfixes, libXrender, libjpeg_original
}:
 let
   libjpeg_original_fix = libjpeg_original.overrideAttrs (oldAttrs: {
    src = fetchurl{
      url = http://www.ijg.org/files/jpegsrc.v8d.tar.gz;
      sha256 = "1cz0dy05mgxqdgjf52p54yxpyy95rgl30cnazdrfmw7hfca9n0h0";
    };
  });
in
stdenv.mkDerivation rec {
  version = "2.1.7300.1";
  name = "sky-${version}";
  src = fetchurl {
    url = "https://tel.red/repos/archlinux/sky-archlinux-${(lib.concatStringsSep "." (lib.take 3 (lib.splitString "." version))) + "-" + (lib.last (lib.splitString "." version))}-x86_64.pkg.tar.xz";
    sha256 = "1423d4c091faa56fcda5ccf53c87a151a8fe7f1cc8cda748c4198cb51f7b7143";
  };
  buildInputs = [ 
    stdenv
    file
    gcc-unwrapped
    qt5.qtbase
    SDL
    ffmpeg-full
    sqlite
    openssl_1_1_0
    openh264
    pam
    curl
    libX11 libXScrnSaver libGL libpulseaudio libXrandr libXext libXcursor libXinerama libXi libuuid libv4l libxkbfile libXv zlib libXmu libXtst libXdamage libXfixes libXrender
    libjpeg_original_fix
];
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin" "$out/lib" "$out/share"
    cp -a lib/sky/lib/* "$out/lib/"
    cp -a lib/sky/sky "$out/bin"
    cp -a lib/sky/man.sh "$out/bin"
    cp -a share/* "$out/share"
    chmod +x $out/bin/sky
  '';

  postFixup = ''
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libfreerdp-client.so.2.0.0
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libfreerdp-server.so.2.0.0
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libfreerdp-shadow.so.2.0.0
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libfreerdp.so.2.0.0
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libopenh264.so.0
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/librdtk.so.1.1.0
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libSDL-1.3.so.0.0.0
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libsipw.so.1.0.0
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libwinpr.so.1.1.0
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libxfreerdp-client.so.2.0.0
    patchelf --set-rpath $out/lib:${stdenv.lib.makeLibraryPath buildInputs} --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/sky
    sed -i "s#/usr/bin/sky#$out/bin/sky#g" $out/share/applications/sky.desktop
    sed -i "s#/usr/lib/sky#$out/bin/#g" $out/share/applications/sky.desktop
  '';

  meta = with stdenv.lib;{
    description = "Skype for business";
    longDescription = ''
      Lync & Skype for business on linux
    '';
    homepage = https://tel.red/;
    license = licenses.unfree;
    maintainers = [ maintainers.Scriptkiddi ];
    platforms = platforms.linux;
  };
}

