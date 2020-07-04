{makeDesktopItem,sudo,gnome2,atk,gdk-pixbuf,libSM,pango,libGLU, fetchurl, zsnes, lib, corefonts, stdenv, dpkg, glibc, xorg_sys_opengl, gcc-unwrapped, zulip, autoPatchelfHook }:

stdenv.mkDerivation rec{
version = "1-6d";
name = "LDCad-${version}-Linux";
  src = fetchurl {
    url = "http://www.melkert.net/action/download/${name}.tar.bz2";
    sha256 = "8dd7d179ca69b79ccd2b1adc20183fad4366937e0d992342bc4fd85898dd3e99";
  };

  nativeBuildInputs = [autoPatchelfHook];
#  runtimeInputs = []; 
  buildInputs = [gnome2.gtk glibc libGLU libSM gdk-pixbuf atk ]; #cairo pango corefonts
  libs = stdenv.lib.makeLibraryPath []; 

unpackPhase = ''
    cp $src ${name}.tar.bz2
    tar xvjf ${name}.tar.bz2 > /dev/null
    cd ${name}
  '';

  installPhase = ''
  appdir="$out/opt"
  datadir="$out/share/LDCad"
  desktopFile="$out/share/applications/LDCad.desktop"
  cfgfn="LDCad.cfg"
  userdir="<userAppDataDir>/.LDCad"
  mimebasedir="$out/share/mime"
  mimedir="$mimebasedir/packages"
  mimefn="$mimedir/ldraw.xml"


#choose the 32 or 64 bit executable
if [ -e "LDCad" ]
then
 appSrcExe="LDCad"
else
 if [ `getconf LONG_BIT` = "64" ]
 then
  appSrcExe="LDCad64"
 else
  appSrcExe="LDCad32"
 fi
fi

mkdir -p $out/{bin,opt/etc,share/applications,share/mime/packages}
cp -v $appSrcExe $appdir/LDCad

cat > $out/bin/LDCad << EOF
    #!${stdenv.shell}

    echo "Launched from wrapper"
    if [ ! -e ~/.LDCad/gui/default/fonts ];
    then 
      mkdir -p ~/.LDCad/gui/default/
      ln -s ${corefonts}/share/fonts ~/.LDCad/gui/default/
    fi
    $out/opt/LDCad
EOF

echo "#!/usr/bin/env xdg-open" > $desktopFile
echo "[Desktop Entry]" >> $desktopFile
echo "Type=Application" >> $desktopFile
echo "Version=1.0" >> $desktopFile
echo "Name=LDCad" >> $desktopFile
echo "GenericName=LDraw model editor" >> $desktopFile
echo "Comment=LDCad can be used to edit all kinds of LDraw (virtual LEGO(r)) models." >> $desktopFile
echo "Icon=$out/share/LDCad/resources/LDCad-128x128.png" >> $desktopFile
echo "Exec=$out/opt/LDCad" >> $desktopFile
echo "Terminal=false" >> $desktopFile
echo "MimeType=application/x-ldraw;application/x-multipart-ldraw" >> $desktopFile
echo "Categories=Graphics" >> $desktopFile

chmod +x $out/bin/LDCad

mkdir -p $datadir/seeds
cp -v seeds/*.sf $datadir/seeds
cp -vr docs $datadir
cp -vr resources $datadir

echo "Creating config file: $cfgfn"
echo "[paths]" > $cfgfn
echo "resourcesDir=$datadir/resources" >> $cfgfn
echo "seedsDir=$datadir/seeds" >> $cfgfn
echo "logDir=$userdir/logs" >> $cfgfn
echo "cfgDir=$userdir/config" >> $cfgfn
echo "guiDir=$userdir/gui" >> $cfgfn
echo "colorBinDir=$userdir/colorBin" >> $cfgfn
echo "partBinDir=$userdir/partBin" >> $cfgfn
echo "examplesDir=$userdir/examples" >> $cfgfn
echo "templatesDir=$userdir/templates" >> $cfgfn
echo "donorsDir=$userdir/donors" >> $cfgfn
echo "shadowDir=$userdir/shadow" >> $cfgfn
echo "scriptsDir=$userdir/scripts" >> $cfgfn
echo "povCfgDir=$userdir/povray" >> $cfgfn
mv $cfgfn $appdir

#Register ldraw mime type
if [ -e "$mimefn" ]
then
  echo "Skipping mime type stuff, file \"$mimefn\" already exists."
else
  echo "Creating ldraw mime type file: $mimefn"
  
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $mimefn
  echo "<mime-info xmlns=\"http://www.freedesktop.org/standards/shared-mime-info\">" >> $mimefn
  echo "   <mime-type type=\"application/x-ldraw\">" >> $mimefn
  echo "     <comment>LDraw Model</comment>" >> $mimefn
  echo "     <glob pattern=\"*.ldr\"/>" >> $mimefn
  echo "     <glob pattern=\"*.LDR\"/>" >> $mimefn
  echo "   </mime-type>" >> $mimefn
  echo "   <mime-type type=\"application/x-multipart-ldraw\">" >> $mimefn
  echo "     <comment>LDraw Model</comment>" >> $mimefn
  echo "     <glob pattern=\"*.mpd\"/>" >> $mimefn
  echo "     <glob pattern=\"*.MPD\"/>" >> $mimefn
  echo "   </mime-type>" >> $mimefn  
  echo "</mime-info>" >> $mimefn

fi
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.melkert.net/LDCad";
    description = "Lego CAD software";
    platforms = platforms.linux;
    maintainers = with maintainers; [ jrobinson_uk ];
  };
}
