{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  patchelfUnstable,
  openssl,
}:

# Use techniques described in https://web.archive.org/web/20220904051329/https://tapesoftware.net/replace-symbol/

# Adapted from https://github.com/KenMacD/etc-nixos/blob/d3d28085586358a62b2bb4b427eb21aad05b5b23/dcc/default.nix

# Used https://github.com/NixOS/nixpkgs/pull/84926 as a template
# then converted to use autoPatchelfHook instead, and link with
# the dependencies from other pkgs.

let
  version = "5.1.0-6";

  unpacked = stdenv.mkDerivation (finalAttrs: {
    inherit version;
    pname = "dell-command-configure-unpacked";

    src = fetchurl {
      urls = [
        "https://dl.dell.com/FOLDER12705845M/1/command-configure_${version}.ubuntu24_amd64.tar.gz"
        "https://web.archive.org/web/20250421172156/https://dl.dell.com/FOLDER12705845M/1/command-configure_5.1.0-6.ubuntu24_amd64.tar.gz"
      ];
      # The CDN blocks the Curl user-agent, so set to blank instead.
      curlOpts = ''-A=""'';
      hash = "sha256-MM6Djkz/VuVCLHGEji88Xq0vIV+AfqQkjNXz4zqFOtw=";
    };

    dontBuild = true;

    nativeBuildInputs = [ dpkg ];

    unpackPhase = ''
      tar -xzf ${finalAttrs.src}
      dpkg-deb -x command-configure_${version}.ubuntu24_amd64.deb command-configure
      dpkg-deb -x srvadmin-hapi_9.5.0_amd64.deb srvadmin-hapi
    '';

    installPhase = ''
      mkdir $out
      cp -r . $out
    '';
  });

  # Contains a fopen() wrapper for finding the firmware package
  wrapperLibName = "wrapper-lib.so";
  wrapperLib = stdenv.mkDerivation {
    pname = "dell-command-configure-unpacked-wrapper-lib";
    inherit version;

    unpackPhase = ''
      cp ${./wrapper-lib.c} wrapper-lib.c
    '';

    postPatch = ''
      substitute wrapper-lib.c lib.c \
        --subst-var-by to "${unpacked}/srvadmin-hapi/opt/dell/srvadmin/etc/omreg.d/omreg-hapi.cfg"
      cc -fPIC -shared lib.c -o ${wrapperLibName}
    '';
    installPhase = ''
      install -D ${wrapperLibName} -t $out/lib
    '';
  };

in
stdenv.mkDerivation {
  inherit version;
  pname = "dell-command-configure";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    openssl
    (lib.getLib stdenv.cc.cc)
  ];

  dontConfigure = true;

  src = unpacked;

  installPhase = ''
    runHook preInstall

    install -D -t $out/lib -m644 -v command-configure/opt/dell/dcc/libhapiintf.so
    install -D -t $out/lib -m644 -v command-configure/opt/dell/dcc/libsmbios_c.so.2
    install -D -t $out/bin -m755 -v command-configure/opt/dell/dcc/cctk
    install -D -t $out/bin -m755 -v srvadmin-hapi/opt/dell/srvadmin/sbin/dchcfg
    for lib in $(find srvadmin-hapi/opt/dell/srvadmin/lib64 -type l); do
        install -D -t $out/lib -m644 -v $lib
    done

    runHook postInstall
  '';

  postFixup = ''
    echo fopen fopen_wrapper > fopen_name_map
    echo access access_wrapper > access_name_map
    ${patchelfUnstable}/bin/patchelf \
      --rename-dynamic-symbols fopen_name_map \
      --rename-dynamic-symbols access_name_map \
      --add-needed ${wrapperLibName} \
      --set-rpath ${lib.makeLibraryPath [ wrapperLib ]} \
      $out/lib/*
  '';

  meta = {
    description = "Configure BIOS settings on Dell laptops";
    homepage = "https://www.dell.com/support/article/us/en/19/sln311302/dell-command-configure";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ryangibb ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
