# Thank god for the zoom-us repo, lots of this is based on that
# I tried to patch the binary but it hard depends on /usr/bin/gsettings and almost certainly some other stuff
{
  stdenv,
  wrapGAppsHook3,
  fetchurl,
  pkgs,
  buildFHSEnvBubblewrap,
  lib,
}:
# Fairly self explanatory, fetch the .deb, unpack it, set up the output for the fhsenv and wrap
# gapp stuff
let
  pname = "numaplayer";
  version = "2.1.8";
  numaplayer = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://www.studiologic-music.com/api/get-files/NumaPlayer_${version}.deb";
      sha256 = "sha256-6GVQ4KiX9y4odDr85kqN+3kZP7+Ac/W+lnbmLiJ/rv0=";
    };

    buildInputs = with pkgs; [
      dpkg
    ];

    nativeBuildInputs = [
      wrapGAppsHook3
    ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      dpkg -x $src .
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r usr/* $out

      runHook postInstall
    '';
  };
in
buildFHSEnvBubblewrap {
  inherit numaplayer;
  name = pname;

  targetPkgs =
    with pkgs;
    pkgs: [
      # Dependencies found via autoPatchelfHook
      # It seems typical to have this declared at the top of the file but it didn't seem to like
      # glib.dev or stdenv.cc.cc so I left it here; lmk if it needs changing
      numaplayer
      freetype
      fontconfig
      curl
      glib
      glib.dev
      pipewire
      stdenv.cc.cc
      alsa-lib
      dconf
      # I'm not entirely sure that these are all necessary, but I don't want to risk something not
      # working in a different environment. These are all from the zoom-us dependencies.
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxrender
      libxtst
      libxcb
      libxshmfence
      libxcb-cursor
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libxcb-wm
    ];

  # Numa player wants to do a lot of config work in home
  extraBwrapArgs = [
    "--bind $HOME $HOME"
  ];

  # Vst3 plugin in /usr/lib, .desktop file in /usr/share/applications
  # I wanted to link the plugin to ~/.vst3 or something but I wasn't sure how or what the convention was
  # and the aur package leaves it in /usr/lib
  extraInstallCommands = ''
    cp -r ${numaplayer}/lib $out/lib

    cp -r ${numaplayer}/share $out/share
    substituteInPlace \
      $out/share/applications/Numa\ Player.desktop \
      --replace-fail \"/usr/bin/Numa\ Player\" numaplayer
  '';

  runScript = "'/bin/Numa Player'";

  meta = {
    homepage = "https://www.studiologic-music.com/products/numaplayer/";
    description = "Virtual instrument and DAW plugin";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sabrinaishere ];
    mainProgram = "numaplayer";
    license = lib.licenses.unfree;
  };
}
