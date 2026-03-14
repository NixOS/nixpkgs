{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  makeWrapper,
  zlib,
  openssl,
  cacert,
  curl,
  libuuid,
  numactl,
}:

stdenv.mkDerivation rec {
  pname = "mlperf-client";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/mlcommons/mlperf_client/releases/download/v${version}/mlperf-client-1.5.0-8665cb1-ubuntu-24.04.zip";
    sha256 = "0b4785e4bdaedf969440036abc7b29faf9513c5c14e1fb201c5ee623c9ac952f";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    zlib
    openssl
    curl
    libuuid
    numactl
    stdenv.cc.cc.lib # libgcc_s.so.1, libstdc++.so.6
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin $out/share/mlperf-client

    #
    install -m755 mlperf-linux $out/bin/mlperf-client

    #
    cp -r Llama3.1 phi3.5 extended EULA $out/share/mlperf-client/

    # Создаем wrapper
    makeWrapper $out/bin/mlperf-client $out/bin/mlperf-client \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      --set SSL_CERT_DIR "${cacert}/etc/ssl/certs"
  '';

  meta = with lib; {
    description = "MLPerf Client benchmark for ML inference on client devices";
    homepage = "https://github.com/mlcommons/mlperf_client";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
