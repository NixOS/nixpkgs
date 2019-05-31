{ stdenv, fetchurl, file, lib, libX11, libXScrnSaver
, libGL, qt5, SDL, libpulseaudio
, libXrandr, libXext, libXcursor, libXinerama, libXi
, curl, sqlite, openssl
, libuuid, openh264, libv4l, libxkbfile, libXv, zlib, libXmu
, libXtst, libXdamage, pam, patchelfUnstable, libXfixes, libXrender, libjpeg_original
, ffmpeg
}:
 let
   # Sky is linked to the libjpeg 8 version and checks for the version number in the code.
   libjpeg_original_fix = libjpeg_original.overrideAttrs (oldAttrs: {
    src = fetchurl{
      url = https://www.ijg.org/files/jpegsrc.v8d.tar.gz;
      sha256 = "1cz0dy05mgxqdgjf52p54yxpyy95rgl30cnazdrfmw7hfca9n0h0";
    };
  });
in
stdenv.mkDerivation rec {
  version_major = "2.1.7369";
  version_minor = "1";
  version = version_major + "." + version_minor;
  name = "sky-${version}";
  unpackCmd = "ar x $curSrc; tar -xf data.tar.xz";
  src = fetchurl {
    url = "https://tel.red/repos/ubuntu/pool/non-free/sky_${version_major + "-" + version_minor}ubuntu+xenial_amd64.deb";
    sha256 = "0b3j90km3rp5bgaklxw881g0gcy09mqzbhjdfrq4s2np026ql3d9";
  };
  buildInputs = [ 
    file
    qt5.qtbase
    SDL
    ffmpeg
    sqlite
    openssl
    openh264
    pam
    curl
    libX11 libXScrnSaver libGL libpulseaudio libXrandr
    libXext libXcursor libXinerama libXi libuuid libv4l
    libxkbfile libXv zlib libXmu libXtst libXdamage
    libXfixes libXrender
    libjpeg_original_fix
  ];
  dontBuild = true;

  installPhase = ''
    ls -al ./
    mkdir -p "$out/bin" "$out/lib" "$out/share"
    cp -a lib/sky/* $out/bin/
    cp -aR lib/sky/lib64/* "$out/lib/"
    cp -a lib/sky/man.sh "$out/bin"
    chmod +x $out/bin/sky
    cp -a share/* "$out/share"
  ''
  ;


  postFixup = ''
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libfreerdp-client.so.2.0.0
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libfreerdp-server.so.2.0.0
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libfreerdp-shadow.so.2.0.0
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libfreerdp.so.2.0.0
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libopenh264.so.0
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/librdtk.so.1.1.0
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libSDL-1.3.so.0.0.0
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libsipw.so.1.0.0
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libwinpr.so.1.1.0
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} $out/lib/libxfreerdp-client.so.2.0.0
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/sky
    patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}:${stdenv.lib.makeLibraryPath buildInputs} --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/sky_sender
    sed -i "s#/usr/bin/sky#$out/bin/sky#g" $out/share/applications/sky.desktop
    sed -i "s#/usr/lib/sky#$out/bin/#g" $out/share/applications/sky.desktop
  '';

  meta = with stdenv.lib; {
    description = "Skype for business";
    longDescription = ''
      Lync & Skype for business on linux
    '';
    homepage = https://tel.red/;
    license = licenses.unfree;
    maintainers = [ maintainers.Scriptkiddi ];
    platforms = platforms.unix;
  };
}

