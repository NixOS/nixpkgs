{ lib, stdenv, fetchzip, autoPatchelfHook, fetchurl, xar, cpio }:

stdenv.mkDerivation rec {
  pname = "1password-cli";
  version = "2.0.0";
  src =
    if stdenv.isLinux then
      fetchzip
        {
          url = {
            "i686-linux" = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_linux_386_v${version}.zip";
            "x86_64-linux" = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_linux_amd64_v${version}.zip";
            "aarch64-linux" = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_linux_arm64_v${version}.zip";
          }.${stdenv.hostPlatform.system};
          sha256 = {
            "i686-linux" = "sha256-vCxgEBq4YVfljq2zUpvBdZUbIiam4z64P1m9OMWq1f4=";
            "x86_64-linux" = "sha256-CDwrJ5ksXf9kwHobw4jvRUi1hLQzq4/yRlk+kHPN7UE=";
            "aarch64-linux" = "sha256-NhCs68on8LzoeOmM5eP8LwmFaVWz6aghqtHzfUlACiA=";
          }.${stdenv.hostPlatform.system};
          stripRoot = false;
        } else
      fetchurl {
        url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_apple_universal_v${version}.pkg";
        sha256 = "sha256-DC9hdzRjQ9iNjbe6PfRpMXzDeInq4rYSAa2nDHQMTRo=";
      };

  buildInputs = lib.optionals stdenv.isDarwin [ xar cpio ];

  unpackPhase = lib.optionalString stdenv.isDarwin ''
    xar -xf $src
    zcat op.pkg/Payload | cpio -i
  '';

  installPhase = ''
    install -D op $out/bin/op
  '';

  dontStrip = stdenv.isDarwin;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/op --version
  '';

  meta = with lib; {
    description = "1Password command-line tool";
    homepage = "https://developer.1password.com/docs/cli/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI2";
    maintainers = with maintainers; [ joelburget marsam ];
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
  };
}
