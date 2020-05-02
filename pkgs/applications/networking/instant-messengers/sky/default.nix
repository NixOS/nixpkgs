{ stdenv, fetchurl, file, libX11, libXScrnSaver
, libGL, qt5, SDL, libpulseaudio
, libXrandr, libXext, libXcursor, libXinerama, libXi
, curl, sqlite, openssl
, libuuid, openh264, libv4l, libxkbfile, libXv, zlib, libXmu
, libXtst, libXdamage, pam, libXfixes, libXrender, libjpeg_original
, ffmpeg_4, autoPatchelfHook
}:
 let
   # Sky is linked to the libjpeg 8 version and checks for the version number in the code.
   libjpeg_original_fix = libjpeg_original.overrideAttrs (oldAttrs: {
    src = fetchurl{
      url = "https://www.ijg.org/files/jpegsrc.v8d.tar.gz";
      sha256 = "1cz0dy05mgxqdgjf52p54yxpyy95rgl30cnazdrfmw7hfca9n0h0";
    };
  });
in
stdenv.mkDerivation rec {
  version_major = "2.1.7520";
  version_minor = "1";
  version = version_major + "." + version_minor;
  pname = "sky";
  unpackCmd = "ar x $curSrc; tar -xf data.tar.xz";
  src = fetchurl {
    url = "https://tel.red/repos/ubuntu/pool/non-free/sky_${version_major + "-" + version_minor}ubuntu+eoan_amd64.deb";
    sha256 = "1pjybzks05vf9s49affwis5w80szizwvxmkgmgyfj7v707r1z5ia";
  };
  buildInputs = [ 
    file
    qt5.qtbase
    SDL
    ffmpeg_4
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
  nativeBuildInputs = [
    autoPatchelfHook
    qt5.wrapQtAppsHook
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
    sed -i "s#/usr/bin/sky#$out/bin/sky#g" $out/share/applications/sky.desktop
    sed -i "s#/usr/lib/sky#$out/bin/#g" $out/share/applications/sky.desktop
  '';

  meta = with stdenv.lib; {
    description = "Skype for business";
    longDescription = ''
      Lync & Skype for business on linux
    '';
    homepage = "https://tel.red/";
    license = licenses.unfree;
    maintainers = [ maintainers.Scriptkiddi ];
    platforms = platforms.unix;
  };
}

