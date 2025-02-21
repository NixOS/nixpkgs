{
  autoPatchelfHook,
  fetchzip,
  lib,
  libfprint-tod,
  openssl,
  patchelfUnstable, # have to use patchelfUnstable to support --rename-dynamic-symbols
  stdenv,
}:

# Based on ideas from (using a wrapper library to redirect fopen() calls to firmware files):
#   * https://tapesoftware.net/replace-symbol/
#   * https://github.com/NixOS/nixpkgs/pull/260715
let
  pname = "libfprint-2-tod1-broadcom";
  version = "5.12.018";

  src = fetchzip {
    url = "http://dell.archive.canonical.com/updates/pool/public/libf/${pname}/${pname}_${version}.orig.tar.gz";
    hash = "sha256-0C2PpYpEJNrU+8NT95w4QV0J5nHQisMY94Czw3jQOzw=";
    pname = "${pname}-unpacked";
    inherit version;
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
        --subst-var-by to "${src}/var/lib/fprint/fw"
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
    patchelfUnstable
  ];

  installPhase = ''
    runHook preInstall
    install -D -t "$out/lib/libfprint-2/tod-1/" -m 644 -v usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-2-tod-1-broadcom.so
    install -D -t "$out/lib/udev/rules.d/"      -m 644 -v lib/udev/rules.d/60-libfprint-2-device-broadcom.rules
    runHook postInstall
  '';

  postFixup = ''
    echo fopen64 fopen_wrapper > fopen_name_map
    patchelf \
      --rename-dynamic-symbols fopen_name_map \
      --add-needed ${wrapperLibName} \
      "$out/lib/libfprint-2/tod-1/libfprint-2-tod-1-broadcom.so"
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = with lib; {
    description = "Broadcom driver module for libfprint-2-tod Touch OEM Driver (from Dell)";
    homepage = "http://dell.archive.canonical.com/updates/pool/public/libf/libfprint-2-tod1-broadcom/";
    license = licenses.unfree;
    maintainers = with maintainers; [ pitkling ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
