{ lib
, writeShellScript
, buildFHSEnv
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, nss
, libvorbis
, libdrm
, libGL
, wayland
, libthai
}:

let
  pname = "insync";
  version = "3.8.5.50499";
  meta = with lib; {
    platforms = ["x86_64-linux"];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ hellwolf ];
    homepage = "https://www.insynchq.com";
    description = "Google Drive sync and backup with multiple account support";
    longDescription = ''
     Insync is a commercial application that syncs your Drive files to your
     computer.  It has more advanced features than Google's official client
     such as multiple account support, Google Doc conversion, symlink support,
     and built in sharing.

     There is a 15-day free trial, and it is a paid application after that.

     Known bug(s):

     1) Currently the system try icon does not render correctly.
     2) libqtvirtualkeyboardplugin does not have necessary Qt library shipped from vendor.
    '';
  };
  insync-pkg = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      # Find a binary from https://www.insynchq.com/downloads/linux#ubuntu.
      url = "https://cdn.insynchq.com/builds/linux/${pname}_${version}-lunar_amd64.deb";
      sha256 = "sha256-mpMJe8LAmO9OrqRIEWuxfVNeh5ANvjZIEHFz8cXYObY=";
    };

    buildInputs = [
      nss
      libvorbis
      libdrm
      libGL
      wayland
      libthai
    ];

    nativeBuildInputs = [ autoPatchelfHook dpkg ];

    unpackPhase = ''
      dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/lib $out/share
      cp -R usr/* $out/

      # use system glibc
      rm -f $out/lib/insync/{libgcc_s.so.1,libstdc++.so.6}

      # remove badly packaged plugins
      rm $out/lib/insync/PySide2/plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so

      runHook postInstall
    '';

    dontConfigure = true;
    dontBuild = true;

    # NB! This did the trick, otherwise it segfaults! However I don't understand why!
    dontStrip = true;

    inherit meta;
  };
in buildFHSEnv { # ref: pkgs/build-support/build-fhsenv-bubblewrap/default.nix
  name = "${pname}-${version}";
  inherit meta;

  # for including insync's xdg data dirs
  extraOutputsToInstall = [ "share" ];

  targetPkgs = pkgs: [
    insync-pkg
  ];

  multiPkgs = pkgs: with pkgs; [
    # apparently only package needed for the FHS :)
    libudev0-shim
  ];

  runScript = writeShellScript "insync-wrapper.sh" ''
    # QT_STYLE_OVERRIDE was used to suppress a QT warning, it should have no actual effect for this binary.
    export QT_STYLE_OVERRIDE=Fusion
    exec "${insync-pkg.outPath}/lib/insync/insync" "$@"
  '';
  # "insync start" command starts a daemon.
  dieWithParent = false;
}
