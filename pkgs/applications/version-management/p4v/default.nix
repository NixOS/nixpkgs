{ stdenv
, fetchurl
, lib
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
, nss
, qttools
, qtwebengine
, xcbutilimage
, xcbutilkeysyms
, xcbutilrenderutil
, xcbutilwm
}:

let
  pname = "p4v";
  version = "2022.2.2336701";

  unwrapped = stdenv.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://web.archive.org/web/20220902181457/https://ftp.perforce.com/perforce/r22.2/bin.linux26x86_64/p4v.tgz";
      sha256 = "8fdade4aafe25f568a61cfd80823aa90599c2a404b7c6b4a0862c84b07a9f8d2";
    };

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

    meta = {
      description = "Perforce Helix Visual Client";
      homepage = "https://www.perforce.com";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfreeRedistributable;
      platforms = [ "x86_64-linux" ];
      maintainers = with lib.maintainers; [ impl nathyong nioncode ];
    };
  };
in
stdenv.mkDerivation {
  inherit pname version;

  # Build a "clean" version of the package so that we don't add extra ".bin" or
  # configuration files to users' PATHs. We can't easily put the unwrapped
  # package files in libexec (where they belong, probably) because the upstream
  # wrapper scripts have the bin directory hardcoded.
  buildCommand = ''
    mkdir -p $out/bin
    for f in p4admin p4merge p4v p4vc; do
      ln -s ${unwrapped}/bin/$f $out/bin
    done
  '';
  preferLocalBuild = true;

  inherit (unwrapped) meta passthru;
}
