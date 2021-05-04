{ lib
, stdenv
, fetchurl
, makeWrapper
, electron_11
, openssl
}:

stdenv.mkDerivation rec {
  pname = "1password";
  version = "8.0.33-53.BETA";

  src = fetchurl {
    url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
    hash = "sha256-YUYER+UiM1QEDgGl0P9bIT65YVacUnuGtQVkV91teEU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = let
    runtimeLibs = [
      openssl.out
      stdenv.cc.cc
    ];
  in ''
    mkdir -p $out/bin $out/share/1password

    # Applications files.
    cp -a {locales,resources} $out/share/${pname}
    install -Dm0755 -t $out/share/${pname} {1Password-BrowserSupport,1Password-KeyringHelper}

    # Desktop file.
    install -Dt $out/share/applications resources/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=/opt/1Password/${pname}' 'Exec=${pname}'

    # Icons.
    cp -a resources/icons $out/share

    # Wrap the application with Electron.
    makeWrapper "${electron_11}/bin/electron" "$out/bin/${pname}" \
      --add-flags "$out/share/${pname}/resources/app.asar" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

    # Set the interpreter for the helper binaries and wrap them with
    # the runtime libraries.
    interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
    patchelf --set-interpreter $interp \
      $out/share/$pname/{1Password-BrowserSupport,1Password-KeyringHelper}

    wrapProgram $out/share/${pname}/1Password-BrowserSupport \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

    wrapProgram $out/share/${pname}/1Password-KeyringHelper \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Multi-platform password manager";
    longDescription = ''
      1Password is a multi-platform package manager.

      The Linux version is currently a development preview and can
      only be used to search, view, and copy items. However items
      cannot be created or edited.
    '';
    homepage = "https://1password.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ danieldk timstott ];
    platforms = [ "x86_64-linux" ];
  };
}
