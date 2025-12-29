{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  libgcc,
}:
let
  system = stdenv.hostPlatform.system;
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/go/goland-2025.3.tar.gz";
      sha256 = "6151856286ea546eb8af9aeb025772cee6bd57134f45494a818e8da20a8691c6";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/go/goland-2025.3-aarch64.tar.gz";
      sha256 = "c530dd4bcc7a075a040b64859ecb34142c8fc0399625c5a13ae2d7a8f5974340";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2025.3.dmg";
      sha256 = "e1df4f10b158c7788736559666244e994500a40db5b08661e2691357d269dbf4";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2025.3-aarch64.dmg";
      sha256 = "d4ee20b5c3df6151d366d6cc9b06b915499ff0c1eb1184aab53a01078908ec89";
    };
  };
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "goland";

  wmClass = "jetbrains-goland";
  product = "Goland";

  version = "2025.3";
  buildNumber = "253.28294.337";

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  extraWrapperArgs = [
    # fortify source breaks build since delve compiles with -O0
    ''--prefix CGO_CPPFLAGS " " "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0"''
  ];
  buildInputs = [
    libgcc
  ];

  meta = {
    homepage = "https://www.jetbrains.com/go/";
    description = "Go IDE from JetBrains";
    longDescription = "Goland is the codename for a new commercial IDE by JetBrains aimed at providing an ergonomic environment for Go development.
          The new IDE extends the IntelliJ platform with the coding assistance and tool integrations specific for the Go language";
    maintainers = with lib.maintainers; [ tymscar ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}).overrideAttrs
  (attrs: {
    postFixup =
      (attrs.postFixup or "")
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
        chmod +x $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
      '';
  })
