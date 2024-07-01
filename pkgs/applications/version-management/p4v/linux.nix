{ lib
, stdenv
, autoPatchelfHook
, cups
, dbus
, fontconfig
, gccForLibs
, libX11
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXi
, libXrandr
, libXrender
, libXtst
, libinput
, libxcb
, libxkbcommon
, makeWrapper
, nss
, qttools
, qtwebengine
, xcbutilimage
, xcbutilkeysyms
, xcbutilrenderutil
, xcbutilwm
}:

{ pname, version, src, meta }:
let
  unwrapped = stdenv.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version src meta;

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      cups
      dbus
      fontconfig
      gccForLibs
      libX11
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXi
      libXrandr
      libXrender
      libXtst
      libinput
      libxcb
      libxkbcommon
      nss
      qttools
      qtwebengine
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      xcbutilwm
    ];

    dontBuild = true;

    # Don't wrap the Qt apps; upstream has its own wrapper scripts.
    dontWrapQtApps = true;

    installPhase = ''
      mkdir -p $out
      cp -r bin lib $out
      addAutoPatchelfSearchPath $out/lib
    '';
  };
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [
    makeWrapper
  ];

  inherit unwrapped;

  # Build a "clean" version of the package so that we don't add extra ".bin" or
  # configuration files to users' PATHs. We can't easily put the unwrapped
  # package files in libexec (where they belong, probably) because the upstream
  # wrapper scripts have the bin directory hardcoded.
  buildCommand = ''
    mkdir -p $out/bin
    for f in p4admin p4merge p4v p4vc; do
      # Qt has trouble finding libdbus-1 dynamically, so we provide a wrapper.
      # When resolved, this could be reduced to a symlink again.
      makeWrapper $unwrapped/bin/$f $out/bin/$f \
        --prefix LD_LIBRARY_PATH : "${lib.getLib dbus}/lib"
    done
  '';
  preferLocalBuild = true;

  inherit (unwrapped) meta passthru;
}
