preInstall() {
    mkdir -p $out/lib/X11/config
    ln -s $xorgcffiles/lib/X11/config/* $out/lib/X11/config
    #touch $out/lib/X11/config/host.def # !!! hack
    #touch $out/lib/X11/config/date.def # !!! hack
}
