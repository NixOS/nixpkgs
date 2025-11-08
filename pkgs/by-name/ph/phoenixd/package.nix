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
  version = "0.7.0";

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
        aarch64-darwin = "sha256-8j3fzT2KWlspp4+5vplbvO6nrd1G+Fox6B6+YB+NE1k=";
        x86_64-darwin = "sha256-f7OwOr0PRkfX6rdddoW4GNvIv16wjAU0G7LiI+oS+xQ=";
        x86_64-linux = "sha256-2oVnY/BjSC3HxfOMlqWyI/Yue3PT+vNWten4ty2DZVk=";
        aarch64-linux = "sha256-oRUXFZwGShZzqNiY18gKm1ZNVJ/zfARhr9d7S4hN8XQ=";
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
