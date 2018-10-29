{ stdenv, pkgs, fetchurl, makeWrapper, wrapGAppsHook, gvfs, gtk3, atomEnv }:

let
  versions = {
    atom = {
      version = "1.32.0";
      sha256 = "0dha8zi4gshxj993ns7ybi7q86pfqwzsasrk3a7b5xrdqbrcm5md";
    };

    atom-beta = {
      version = "1.33.0";
      beta = 0;
      sha256 = "1x4s12zvfd2gjy7mimndbhs6x9k37jq4dyy6r1mzhwfysix74val";
    };
  };

  common = pname: {version, sha256, beta ? null}:
      let fullVersion = version + stdenv.lib.optionalString (beta != null) "-beta${toString beta}";
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

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix "PATH" : "${gvfs}/bin" \
      )
    '';

    buildCommand = ''
      mkdir -p $out/usr/
      ar p $src data.tar.xz | tar -C $out -xJ ./usr
      substituteInPlace $out/usr/share/applications/${pname}.desktop \
        --replace /usr/share/${pname} $out/bin
      mv $out/usr/* $out/
      rm -r $out/share/lintian
      rm -r $out/usr/
      sed -i "s/${pname})/.${pname}-wrapped)/" $out/bin/${pname}

      fixupPhase

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

      paxmark m $share/atom
      paxmark m $share/resources/app/apm/bin/node
    '';

    meta = with stdenv.lib; {
      description = "A hackable text editor for the 21st Century";
      homepage = https://atom.io/;
      license = licenses.mit;
      maintainers = with maintainers; [ offline nequissimus synthetica ysndr ];
      platforms = platforms.x86_64;
    };
  };
in stdenv.lib.mapAttrs common versions
