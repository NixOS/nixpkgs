{ appimageTools, stdenv, fetchurl, unzip } :

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    "x86_64-linux" = "-x86_64";
    "x86_64-darwin" = "";
  }.${system};

  sha256 = {
    "x86_64-linux" = "1pni02mb5bvwx3k45vd6ga269ghdl633gjklyslai24rrhp16h9z";
    "x86_64-darwin" = "1x2gxixir766670b5iglcgzbzmjap1k0n0nhpjhkqvn2ngs8fzq4";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "AppImage";

  pname = "zulip-desktop";
  imageName = "Zulip";
  version = "4.0.0";
  executablename = "${imageName}-${version}${plat}";

  src = fetchurl {
    url = "https://github.com/zulip/${pname}/releases/download/v${version}/${executablename}.${archive_fmt}";
    inherit sha256;
  };

  appimageContents = if !stdenv.isDarwin then
  appimageTools.extractType2 {
    name = executablename;
    inherit src;
  } else {};

  meta = with stdenv.lib; {
    description = "Desktop client for Zulip";
    longDescription = ''
      Zulip is a powerful, open source group chat application that combines the immediacy of real-time chat with the productivity benefits of threaded conversations.
    '';
    homepage = https://zulipchat.com/;
    license = licenses.asl20;
    maintainers = with maintainers; [ kaychaks ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

in {
  deriv = if stdenv.isDarwin then
    stdenv.mkDerivation {
      inherit pname version src meta;
      buildInputs = [ unzip ];
      installPhase = ''
        mkdir -p "$out/Applications/"
        unzip ${src} -d "$out/Applications/"
        chmod +x "$out/Applications/${imageName}.app/Contents/MacOS/${imageName}"
      '';
    }
    else
      appimageTools.wrapType2 rec {
        name = executablename;
        inherit src meta;


        extraInstallCommands = ''
          mv $out/bin/${executablename} $out/bin/${pname}
          install -m 444 -D ${appimageContents}/zulip.desktop $out/share/applications/zulip.desktop
          install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/zulip.png \
          $out/share/icons/hicolor/512x512/apps/zulip.png
          substituteInPlace $out/share/applications/zulip.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
        '';
      };
}
