{ lib, stdenv, fetchzip, autoPatchelfHook, fetchurl, xar, cpio }:

stdenv.mkDerivation rec {
  pname = "1password";
  version = "1.11.2";
  src =
    if stdenv.isLinux then fetchzip {
      url = {
        "i686-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_386_v${version}.zip";
        "x86_64-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
        "aarch64-linux" = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_arm_v${version}.zip";
      }.${stdenv.hostPlatform.system};
      sha256 = {
        "i686-linux" = "0rh5bakj9qd43cf6wj5v46a3h98kcwqyc0f1yw72wvcacvjycyjz";
        "x86_64-linux" = "00nf0cb8cxk1pvzr1wq778wvikzrlzy38r3rzkq44whdpdj50jzx";
        "aarch64-linux" = "1gv282z49bj3ln5na4wb1z5455a64cyd54fp5i96k8shaxd0apxf";
      }.${stdenv.hostPlatform.system};
      stripRoot = false;
    } else fetchurl {
      url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_apple_universal_v${version}.pkg";
      sha256 = "1pqdjr6d23j9fpwgahb0s1ni1bpjv9jajs1hapgq5kdrww2w7nhm";
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
    description  = "1Password command-line tool";
    homepage     = "https://support.1password.com/command-line/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI";
    maintainers  = with maintainers; [ joelburget marsam ];
    license      = licenses.unfree;
    platforms    = [ "i686-linux" "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
  };
}
