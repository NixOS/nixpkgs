{ atk
, buildFHSUserEnv
, cairo
, dpkg
, gdk-pixbuf
, glib
, gtk2-x11
, makeWrapper
, pango
, stdenv
, xorg
}:

{ src, toolName, version, ... } @ attrs:
let
  wrapBinary = libPaths: binaryName: ''
    wrapProgram "$out/bin/${binaryName}" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath libPaths}"
  '';
  pkg = stdenv.mkDerivation (rec {
    inherit (attrs) version src;

    name = "${toolName}-${version}";

    meta = with stdenv.lib; {
      homepage = "http://bitscope.com/software/";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [
        vidbina
      ];
    } // (attrs.meta or {});

    buildInputs = [
      dpkg
      makeWrapper
    ];

    libs = attrs.libs or [
      atk
      cairo
      gdk-pixbuf
      glib
      gtk2-x11
      pango
      xorg.libX11
    ];

    dontBuild = true;

    unpackPhase = attrs.unpackPhase or ''
      dpkg-deb -x ${attrs.src} ./
    '';

    installPhase = attrs.installPhase or ''
      mkdir -p "$out/bin"
      cp -a usr/* "$out/"
      ${(wrapBinary libs) attrs.toolName}
    '';
  });
in buildFHSUserEnv {
  name = "${attrs.toolName}-${attrs.version}";
  runScript = "${pkg.outPath}/bin/${attrs.toolName}";
} // { inherit (pkg) meta name; }
