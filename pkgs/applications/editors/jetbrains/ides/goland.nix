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
      url = "https://download.jetbrains.com/go/goland-2026.2.4.tar.gz";
      hash = "sha256-LZ7ZZrYwxGQEYgnwVxctLI260PGIc4oNRlyWDa6rgU0=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/go/goland-2026.2.4-aarch64.tar.gz";
      hash = "sha256-N0g/RqQa3TtfMZzBCStZEsT0A24/qJ2M/vO+kJoX/2Y=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2026.2.4.dmg";
      hash = "sha256-5KJsKZ/KsoQ6LMwyNwX/1cGdxxliwOjbmSxzllG44kM=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2026.2.4-aarch64.dmg";
      hash = "sha256-ujfGHkY392etAdf4jsqfj4eBOOIBW00vF4ZAZRlkqzM=";
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
  version = "2026.2.4";
  buildNumber = "262.11879.101";
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
