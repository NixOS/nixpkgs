{
  autoPatchelfHook,
  fetchgit,
  lib,
  libfprint-tod,
  openssl,
  patchelfUnstable,
  stdenv,
}:

let
  pname = "libfprint-2-tod1-broadcom-cv3plus";
  version = "6.3.299-6.3.040.0";

  src = fetchgit {
    url = "git://git.launchpad.net/~oem-solutions-engineers/pc-enablement/+git/libfprint-2-tod1-broadcom-cv3plus/";
    branchName = "ubuntu/latest";
    rev = "ac7a8ab2318216e603c8c23b279bbad28a301d3";
    hash = "sha256-4JwoUuvskj8GqTUQpKBECCL+jkSfxpaukqRTTVTmSLk=";
  };

  wrapperLibName = "wrapper-lib.so";
  wrapperLibSource = "wrapper-lib.c";

  # wraps `fopen()` for finding firmware files
  wrapperLib = stdenv.mkDerivation {
    pname = "${pname}-wrapper-lib";
    inherit version;

    src = builtins.path {
      name = "${pname}-wrapper-lib-source";
      path = ./.;
      filter = path: type: baseNameOf path == wrapperLibSource;
    };

    postPatch = ''
      substitute ${wrapperLibSource} lib.c \
        --subst-var-by to "${src}/var/lib/fprint/.broadcomCv3plusFW"
      cc -fPIC -shared lib.c -o ${wrapperLibName}
    '';

    installPhase = ''
      runHook preInstall
      install -D -t $out/lib ${wrapperLibName}
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation {
  inherit src pname version;

  buildInputs = [
    libfprint-tod
    openssl
    wrapperLib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    patchelfUnstable # have to use patchelfUnstable to support --rename-dynamic-symbols
  ];

  installPhase = ''
    runHook preInstall
    install -D -t "$out/lib/libfprint-2/tod-1/" -m 644 -v usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-2-tod-1-broadcom-cv3plus.so
    install -D -t "$out/lib/udev/rules.d/"      -m 644 -v lib/udev/rules.d/60-libfprint-2-device-broadcom-cv3plus.rules
    runHook postInstall
  '';

  postFixup = ''
    echo fopen64 fopen_wrapper > fopen_name_map
    patchelf \
      --rename-dynamic-symbols fopen_name_map \
      --add-needed ${wrapperLibName} \
      "$out/lib/libfprint-2/tod-1/libfprint-2-tod-1-broadcom-cv3plus.so"
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = {
    description = "Broadcom driver module for libfprint-2-tod Touch OEM Driver for Dell ControlVault v3+";
    homepage = "https://git.launchpad.net/~oem-solutions-engineers/pc-enablement/+git/libfprint-2-tod1-broadcom-cv3plus/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      aionescu
      pitkling
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
