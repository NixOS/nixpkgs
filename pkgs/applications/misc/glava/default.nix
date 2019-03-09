{ stdenv, writeScript, fetchFromGitHub
, libGL, libX11, libXext, python3, libXrandr, libXrender, libpulseaudio, libXcomposite
, enableGlfw ? false, glfw, runtimeShell }:

let
  inherit (stdenv.lib) optional makeLibraryPath;

  wrapperScript = writeScript "glava" ''
    #!${runtimeShell}
    case "$1" in
      --copy-config)
        # The binary would symlink it, which won't work in Nix because the
        # garbage collector will eventually remove the original files after
        # updates
        echo "Nix wrapper: Copying glava config to ~/.config/glava"
        cp -r --no-preserve=all @out@/etc/xdg/glava ~/.config/glava
        ;;
      *)
        exec @out@/bin/.glava-unwrapped "$@"
    esac
  '';
in
  stdenv.mkDerivation rec {
    name = "glava-${version}";
    version = "1.6.0";

    src = fetchFromGitHub {
      owner = "wacossusca34";
      repo = "glava";
      rev = "v${version}";
      sha256 = "1zzaq9x98prlgjnb3fxbrnhqpg50f9qqkwl6r4a1xnsfs93qmqpl";
    };

    buildInputs = [
      libX11
      libXext
      libXrandr
      libXrender
      libpulseaudio
      libXcomposite
    ] ++ optional enableGlfw glfw;

    nativeBuildInputs = [
      python3
    ];

    preConfigure = ''
      export CFLAGS="-march=native"
    '';

    makeFlags = optional (!enableGlfw) "DISABLE_GLFW=1";

    installFlags = [
      "DESTDIR=$(out)"
    ];

    fixupPhase = ''
      mkdir -p $out/bin
      mv $out/usr/bin/glava $out/bin/.glava-unwrapped
      rm -rf $out/usr

      patchelf \
        --set-rpath "$(patchelf --print-rpath $out/bin/.glava-unwrapped):${makeLibraryPath [ libGL ]}" \
        $out/bin/.glava-unwrapped

      substitute ${wrapperScript} $out/bin/glava --subst-var out
      chmod +x $out/bin/glava
    '';

    meta = with stdenv.lib; {
      description = ''
        OpenGL audio spectrum visualizer
      '';
      homepage = https://github.com/wacossusca34/glava;
      platforms = platforms.linux;
      license = licenses.gpl3;
      maintainers = with maintainers; [
        eadwu
      ];
    };
  }
