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
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/go/goland-2026.1.4.tar.gz";
      hash = "sha256-pHSbmAZ+tSfa0wdtDp/3Ib/GNMP30OFNQlHWUfMwrW0=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/go/goland-2026.1.4-aarch64.tar.gz";
      hash = "sha256-7s98kY08aKjdRGQLDkffeVhgj1FWurLmTTYmtb5Qx6c=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2026.1.4.dmg";
      hash = "sha256-RbvcLpLVyeL4B1DJ2/9Ub/6Cz6fJGXMPCHsJ705GsAo=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2026.1.4-aarch64.dmg";
      hash = "sha256-y7mEke0z0MvQs+kMtrmrq7EeAtJUbgo6sGZrOB0MraM=";
    };
  };
  # update-script-end: urls
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "goland";

  wmClass = "jetbrains-goland";
  product = "Goland";

  # update-script-start: version
  version = "2026.1.4";
  buildNumber = "261.26222.72";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  extraWrapperArgs = [
    # fortify source breaks build since delve compiles with -O0
    ''--prefix CGO_CPPFLAGS " " "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0"''
  ];
  buildInputs = [
    libgcc
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/go/";
    description = "Go IDE from JetBrains";
    longDescription = ''
      Goland is a commercial IDE by JetBrains aimed at providing an ergonomic environment for Go development.
      The IDE extends the IntelliJ platform with the coding assistance and tool integrations specific for the Go language.
    '';
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
