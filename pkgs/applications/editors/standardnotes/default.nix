{ stdenv, appimageTools, autoPatchelfHook, desktop-file-utils
  , fetchurl, runtimeShell }:

let
  version = "3.3.3";
  pname = "standardnotes";
  name = "${pname}-${version}";

  plat = {
    i386-linux = "-i386";
    x86_64-linux = "";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    i386-linux = "2ccdf23588b09d645811e562d4fd7e02ac0e367bf2b34e373d8470d48544036d";
    x86_64-linux = "6366d0a37cbf2cf51008a666e40bada763dd1539173de01e093bcbe4146a6bd8";
  }.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}${plat}.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  nativeBuildInputs = [ autoPatchelfHook desktop-file-utils ];

in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    # directory in /nix/store so readonly
    cp -r  ${appimageContents}/* $out
    cd $out
    chmod -R +w $out
    mv $out/bin/${name} $out/bin/${pname}

    # fixup and install desktop file
    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value ${pname} standard-notes.desktop

    rm usr/lib/* AppRun standard-notes.desktop .so*
  '';

  meta = with stdenv.lib; {
    description = "A simple and private notes app";
    longDescription = ''
      Standard Notes is a private notes app that features unmatched simplicity,
      end-to-end encryption, powerful extensions, and open-source applications.
    '';
    homepage = "https://standardnotes.org";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mgregoire ];
    platforms = [ "i386-linux" "x86_64-linux" ];
  };
}
