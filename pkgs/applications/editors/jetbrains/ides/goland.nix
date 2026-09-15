{
  # keep-sorted start
  fetchurl,
  fsnotifier,
  jetbrains,
  jetbrains-libdbm,
  lib,
  libgcc,
  stdenv,
  # keep-sorted end
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/go/goland-2026.2.0.1.tar.gz";
      hash = "sha256-nT/jmw0WFNwmtWR5be0KBUHJpM48phhYN7oUNOMCrok=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/go/goland-2026.2.0.1-aarch64.tar.gz";
      hash = "sha256-t6vH7fxtysgprc1EHH3XiIdHD6oCMcY/a1hu5aiYMxE=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2026.2.0.1-aarch64.dmg";
      hash = "sha256-zrQAsOOR4OhAXnebwnRk3da4h4Gi0t8f+SIaEAiwM0Q=";
    };
  };
  # update-script-end: urls
in
(jetbrains.mkJetBrainsProduct {
  inherit jetbrains-libdbm fsnotifier;

  pname = "goland";

  wmClass = "jetbrains-goland";
  product = "Goland";

  # update-script-start: version
  version = "2026.2.0.1";
  buildNumber = "262.8665.336";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

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
    teams = [ lib.teams.jetbrains ];
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
