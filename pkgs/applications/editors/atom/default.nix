{ stdenv, pkgs, fetchurl, wrapGAppsHook, gvfs, gtk3, atomEnv }:

let
  versions = {
    atom = {
      version = "1.48.0";
      sha256 = "1693bxbylf6jhld9bdcr5pigk36wqlbj89praldpz9s96yxig9s1";
    };

    atom-beta = {
      version = "1.49.0";
      beta = 0;
      sha256 = "1fr6m4a7shdj3wpn6g4n95cqpkkg2x9srwjf7bqxv9f3d5jb1y33";
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
        --prefix "PATH" : "${gvfs}/bin"
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

    meta = with stdenv.lib; {
      description = "A hackable text editor for the 21st Century";
      homepage = "https://atom.io/";
      license = licenses.mit;
      maintainers = with maintainers; [ offline nequissimus ysndr ];
      platforms = platforms.x86_64;
    };
  };
in stdenv.lib.mapAttrs common versions
