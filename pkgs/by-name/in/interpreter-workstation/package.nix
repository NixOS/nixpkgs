{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "interpreter";
  version = "latest";

  src = fetchurl {
    url = "https://openinterpreter.com/download/linux/appimage";
    hash = "sha256-fJXSmrT/UaEjK+OUaqQt/jGkE/8gKXTi1qv9EOawQGk=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  profile = ''
    export APPIMAGE=true
  '';

  # Dependencies needed at runtime by the AppImage binary
  extraPkgs =
    pkgs: with pkgs; [
      bubblewrap
      ripgrep
    ];

  extraInstallCommands =
    let
      appimageContents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -m 444 -D ${appimageContents}/interpreter.desktop -t $out/share/applications/

      if [ -f "${appimageContents}/interpreter.png" ]; then
        install -m 444 -D ${appimageContents}/interpreter.png $out/share/icons/hicolor/512x512/apps/${pname}.png
      elif [ -f "${appimageContents}/.DirIcon" ]; then
        install -m 444 -D ${appimageContents}/.DirIcon $out/share/icons/hicolor/512x512/apps/${pname}.png
      fi

      substituteInPlace $out/share/applications/interpreter.desktop \
        --replace-fail "Exec=AppRun" "Exec=${pname}"
    '';

  meta = {
    description = "The desktop agent. Interpreter lets you work alongside agents that can edit your documents, fill PDF forms, and more.";
    homepage = "https://www.openinterpreter.com/desktop";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _2hexed ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "interpreter";
  };
}
