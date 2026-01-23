{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  libgcc,
  libxcrypt-legacy,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phoenixd";
  version = "0.7.1";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      suffix = selectSystem {
        aarch64-darwin = "macos-arm64";
        x86_64-darwin = "macos-x64";
        x86_64-linux = "linux-x64";
        aarch64-linux = "linux-arm64";
      };
    in
    fetchurl {
      url = "https://github.com/ACINQ/phoenixd/releases/download/v${finalAttrs.version}/phoenixd-${finalAttrs.version}-${suffix}.zip";
      hash = selectSystem {
        aarch64-darwin = "sha256-WCXmXBqMQxovBYg9QtgOy/76tu3TeJ91ERusZZRHPhY=";
        x86_64-darwin = "sha256-g23VWjZyt7V1YVoaHi/6M7m/SO7nOr56zt9M5j1t5hU=";
        x86_64-linux = "sha256-m0Ibi1LG6PtdaGFgfhS7UOIhuFprDdJlj6SLzjTW8HY=";
        aarch64-linux = "sha256-UuWoD4WsQA009CcdXLhIfs5VBlCqvX7yOVWyKZxJnlQ=";
      };
    };

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libgcc # provides libgcc_s.so.1
    libxcrypt-legacy # provides libcrypt.so.1
    zlib # provides libz.so.1
  ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 phoenix-cli $out/bin/phoenix-cli
    install -Dm0755 phoenixd $out/bin/phoenixd

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Server equivalent of the popular Phoenix wallet for mobile";
    homepage = "https://phoenix.acinq.co/server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
})
