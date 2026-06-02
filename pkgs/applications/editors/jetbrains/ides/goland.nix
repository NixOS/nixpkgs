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
      url = "https://download.jetbrains.com/go/goland-2026.1.1.tar.gz";
      hash = "sha256-ASzqw8xuRaSAwzoiBsL+6PRyuSvBh43tnF4mEmkur9s=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/go/goland-2026.1.1-aarch64.tar.gz";
      hash = "sha256-25PADBycdas3n6BWSGOJhuMaLcik5P5AfcEO6mY75js=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2026.1.1.dmg";
      hash = "sha256-kKr5/7z5gbL0YORDET0y7LgczWLEQ31lqsrHgkxrzQ8=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2026.1.1-aarch64.dmg";
      hash = "sha256-zfdJrXBatvAl3wNMQ3LhF9oOxo1dEyo8wr4lCoFdm9I=";
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
  version = "2026.1.1";
  buildNumber = "261.23567.143";
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
