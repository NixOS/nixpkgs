{ lib, stdenv, pkgs, fetchurl, wrapGAppsHook, glib, gtk3, atomEnv }:

let
  versions = {
    atom = {
      version = "1.60.0";
      sha256 = "sha256-XHwCWQYrnUkR0lN7/Or/Uxb53hEWmIQKkNfNSX34kaY=";
    };

    atom-beta = {
      version = "1.61.0";
      beta = 0;
      sha256 = "sha256-viY/is7Nh3tlIkHhUBWtgMAjD6HDiC0pyJpUjsP5pRY=";
      broken = true;
    };
  };

  common = pname: {version, sha256, beta ? null, broken ? false}:
      let fullVersion = version + lib.optionalString (beta != null) "-beta${toString beta}";
      name = "${pname}-${fullVersion}";
  in stdenv.mkDerivation {
    inherit name;
    version = fullVersion;

    src = fetchurl {
      url = "https://github.com/atom/atom/releases/download/v${fullVersion}/atom-amd64.deb";
      name = "${name}.deb";
      inherit sha256;
    };

    nativeBuildInputs = [
      wrapGAppsHook  # Fix error: GLib-GIO-ERROR **: No GSettings schemas are installed on the system
    ];

    buildInputs = [
      gtk3  # Fix error: GLib-GIO-ERROR **: Settings schema 'org.gtk.Settings.FileChooser' is not installed
    ];

    dontBuild = true;
    dontConfigure = true;

    unpackPhase = ''
      ar p $src data.tar.xz | tar xJ ./usr/
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      mv usr/bin usr/share $out
      rm -rf $out/share/lintian

      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        # needed for gio executable to be able to delete files
        --prefix "PATH" : "${glib.bin}/bin"
      )
    '';

    postFixup = ''
      share=$out/share/${pname}

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:$share" \
        $share/atom
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}" \
        $share/resources/app/apm/bin/node
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $share/resources/app.asar.unpacked/node_modules/symbols-view/vendor/ctags-linux

      dugite=$share/resources/app.asar.unpacked/node_modules/dugite
      rm -f $dugite/git/bin/git
      ln -s ${pkgs.git}/bin/git $dugite/git/bin/git
      rm -f $dugite/git/libexec/git-core/git
      ln -s ${pkgs.git}/bin/git $dugite/git/libexec/git-core/git

      find $share -name "*.node" -exec patchelf --set-rpath "${atomEnv.libPath}:$share" {} \;

      sed -i -e "s|Exec=.*$|Exec=$out/bin/${pname}|" $out/share/applications/${pname}.desktop
    '';

    meta = with lib; {
      description = "A hackable text editor for the 21st Century";
      homepage = "https://atom.io/";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.mit;
      maintainers = with maintainers; [ offline ysndr ];
      platforms = platforms.x86_64;
      inherit broken;
    };
  };
in lib.mapAttrs common versions
