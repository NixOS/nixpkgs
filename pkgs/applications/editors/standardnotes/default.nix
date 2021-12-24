{ lib, stdenv, appimageTools, autoPatchelfHook, desktop-file-utils
, fetchurl, libsecret, gtk3, gsettings-desktop-schemas }:

let
  version = "3.9.5";
  pname = "standardnotes";
  name = "${pname}-${version}";
  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  plat = {
    i686-linux = "i386";
    x86_64-linux = "x86_64";
  }.${stdenv.hostPlatform.system} or throwSystem;

  sha256 = {
    i686-linux = "sha256-7Mo8ELFV6roZ3IYWBtB2rRDAzJrq4ht9f1v6uohsauw=";
    x86_64-linux = "sha256-9VPYII9E8E3yL7UuU0+GmaK3qxWX4bwfACDl7F7sngo=";
  }.${stdenv.hostPlatform.system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}-linux-${plat}.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  nativeBuildInputs = [ autoPatchelfHook desktop-file-utils ];

in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  extraPkgs = pkgs: with pkgs; [
    libsecret
  ];

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

  meta = with lib; {
    description = "A simple and private notes app";
    longDescription = ''
      Standard Notes is a private notes app that features unmatched simplicity,
      end-to-end encryption, powerful extensions, and open-source applications.
    '';
    homepage = "https://standardnotes.org";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mgregoire chuangzhu ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
