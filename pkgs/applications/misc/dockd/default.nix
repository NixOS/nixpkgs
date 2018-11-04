{ stdenv
, lib
, fetchurl
, cmake
, libXrandr
, libthinkpad
, dockedConfPath ? "/etc/dockd/docked.conf"
, undockedConfPath ? "/etc/dockd/undocked.conf"
, dockHookPath ? "/etc/dockd/dock.hook"
, undockHookPath ? "/etc/dockd/undock.hook"
}:
let
  version = "1.21";
in
stdenv.mkDerivation rec {
   name = "dockd-${ version }";
   src = fetchurl {
      url = "https://github.com/libthinkpad/dockd/archive/${ version }.tar.gz";
      sha256 = "1r2h77zv4r52sdnv977ay3j9lljsd0sgzd0cxp4j3pynr276lspx";
   };
   buildInputs = [ libXrandr libthinkpad ];
   nativeBuildInputs = [ cmake ];
   # the current implementation has the location of the paths hard-coded
   # in the source code, apply the patches to make be able to modify
   # those paths when we build the package
   patches = [ ./CMakeLists.patch ./crtc_h.patch ./hooks_cpp.patch ];
   postPatch = ''
     echo "Replacing DOCKED_CONF_PATH to ${ dockedConfPath }"
     echo "Replacing UNDOCKED_CONF_PATH to ${ undockedConfPath }"
     echo "Replacing DOCK_HOOK_PATH  to ${ dockHookPath }"
     echo "Replacing UNDOCK_HOOK_PATH  to ${ undockHookPath }"
     substituteInPlace crtc.h \
       --subst-var-by DOCKED_CONF_PATH '${ dockedConfPath }' \
       --subst-var-by UNDOCKED_CONF_PATH '${ undockedConfPath }'
     substituteInPlace hooks.cpp \
       --subst-var-by DOCK_HOOK_PATH '${ dockHookPath }' \
       --subst-var-by UNDOCK_HOOK_PATH '${ undockHookPath }'
   '';
   postInstall = ''
     rm -rf $out/etc/
   '';
   meta = with stdenv.lib; {
     description = "A program that detects when your ThinkPad is added or removed from a dock";
     longDescription = ''
       A program that runs in the background and detects when your ThinkPad is added
       or removed from a dock and it automatically switches output mode profiles
       that you have configured before.
     '';
     homepage = https://github.com/libthinkpad/dockd;
     license = [ licenses.bsd2 ];
     maintainers = with maintainers; [ cyraxjoe ];
     platforms = platforms.linux;
   };
}
