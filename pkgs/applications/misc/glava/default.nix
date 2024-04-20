{ lib, stdenv, writeScript, fetchFromGitHub
, libGL, libX11, libXext, python3, libXrandr, libXrender, libpulseaudio, libXcomposite
, enableGlfw ? false, glfw, runtimeShell }:

let
  inherit (lib) optional makeLibraryPath;

  wrapperScript = writeScript "glava" ''
    #!${runtimeShell}
    case "$1" in
      --copy-config|-C)
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
    pname = "glava";
    version = "1.6.3";

    src = fetchFromGitHub {
      owner = "wacossusca34";
      repo = "glava";
      rev = "v${version}";
      sha256 = "0kqkjxmpqkmgby05lsf6c6iwm45n33jk5qy6gi3zvjx4q4yzal1i";
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
      for f in $(find -type f);do
        substituteInPlace $f \
          --replace /etc/xdg $out/etc/xdg
      done

      substituteInPlace Makefile \
        --replace '$(DESTDIR)$(SHADERDIR)' '$(SHADERDIR)'

      substituteInPlace Makefile \
        --replace 'unknown' 'v${version}'
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

    meta = with lib; {
      description = ''
        OpenGL audio spectrum visualizer
      '';
      mainProgram = "glava";
      homepage = "https://github.com/wacossusca34/glava";
      platforms = platforms.linux;
      license = licenses.gpl3;
      maintainers = with maintainers; [
        eadwu
      ];
    };
  }
