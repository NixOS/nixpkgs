{
  lib,
  stdenv,
  fetchurl,
  xdg-utils,
  glib,
  gtk3,
  libGL,
  libx11,
  libxxf86vm,
  libxtst,
  zlib,
  pcsclite,
  buildFHSEnv,
  writeShellScriptBin,
  eparaksts-middleware,
  dpkg,
}:

let
  name = "eparakstitajs3";
  version = "1.10.0";
  dpkg-stub = writeShellScriptBin "dpkg" ''
    if [ "$1" = "-s" ]; then
      if [ "$2" == "latvia-eid-middleware" ]; then
          echo "Package: $2"
          echo "Status: install ok installed"
          echo "Version: ${eparaksts-middleware.version}"
      elif [ "$2" == "eparakstitajs3" ]; then
          echo "Package: $2"
          echo "Status: install ok installed"
          echo "Version: ${version}"
      fi
      exit 0
    fi
    exit 1
  '';

  desktopFile = ./context-actions/eparakstitajs3.desktop;
  eparakstitajs3 = stdenv.mkDerivation {
    inherit version name;
    src = fetchurl {
      url = "https://www.eparaksts.lv/files/ep3updates/debian/pool/eparaksts/e/eparakstitajs3/eparakstitajs3_${version}-resolute_amd64.deb";
      hash = "sha256-jnLGX8CGp66E9nwuf3TkY5XDLIq903k7Q6di6zhn+jo=";
    };

    nativeBuildInputs = [
      dpkg
    ];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    installPhase = ''
      mkdir -p $out/usr/lib $out/usr/share
      cp -r usr/lib/eparakstitajs3/* $out/usr
      cp -r usr/share/* $out/usr/share

      CFG_FILE=$out/usr/lib/app/eparakstitajs3.cfg
      echo "java-options=-Dprism.verbose=true" >> "$CFG_FILE"
      echo "java-options=-Dprism.forceGPU=true" >> "$CFG_FILE"


        mkdir -p $out/usr/share/kio/servicemenus

        cp ${desktopFile} $out/usr/share/kio/servicemenus/eparakstitajs3.desktop
    '';
  };
in
buildFHSEnv {
  inherit version name;

  targetPkgs = pkgs: [
    eparaksts-middleware
    pcsclite
    zlib
    glib
    libx11
    gtk3
    libxtst
    dpkg-stub
    libxxf86vm
    libGL
    xdg-utils
    eparakstitajs3
  ];

  extraInstallCommands = ''
    mkdir -p $out/share
    cp -r ${eparakstitajs3}/usr/share/* $out/share

    substituteInPlace "$out/share/applications/eparakstitajs3.desktop" \
        --replace-fail "/usr/bin/eparakstitajs3 %F" "$out/bin/eparakstitajs3 %F" \
        --replace-fail "/usr/share/eparakstitajs3/eparakstitajs3.xpm" "$out/share/eparakstitajs3/eparakstitajs3.xpm"

    substituteInPlace "$out/share/kio/servicemenus/eparakstitajs3.desktop" \
      --subst-var out
  '';

  runScript = "${eparakstitajs3}/usr/bin/eparakstitajs3";
  meta = {
    description = "eParakstītājs 3.0 signing application";
    homepage = "https://www.eparaksts.lv";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ dshatz ];
    mainProgram = "eparakstitajs3";
    platforms = [ "x86_64-linux" ];
  };
}
