{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  onetbb,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "intel-opencl-runtime";
  version = "2025.3.2-832";

  src = fetchurl {
    url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-shared-runtime-${lib.versions.majorMinor finalAttrs.version}-${finalAttrs.version}_amd64.deb";
    hash = "sha256-E2P3NQ44TeUyMOqtW65rjPxWQEiwEiiesfT5sR2aDew=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    onetbb
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/etc/OpenCL/vendors

    cp -d opt/intel/oneapi/compiler/${lib.versions.majorMinor finalAttrs.version}/lib/* $out/lib
    rm -f $out/lib/libOpenCL.so*
    echo "$out/lib/libintelocl.so" > $out/etc/OpenCL/vendors/intel64.icd

    runHook postInstall
  '';

  meta = {
    description = "Intel oneAPI OpenCL runtime library for Intel Core and Xeon processors";
    homepage = "https://software.intel.com/content/www/us/en/develop/tools/oneapi.html";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ neural-blade ];
  };
})
