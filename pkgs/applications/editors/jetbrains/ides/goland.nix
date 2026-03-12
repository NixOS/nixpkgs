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
      url = "https://download.jetbrains.com/go/goland-2025.3.3.tar.gz";
      hash = "sha256-hyQaZIn102YlXVIYgDu7DyofWkjj1svK7qDhC7hHqlY=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/go/goland-2025.3.3-aarch64.tar.gz";
      hash = "sha256-9eIQ+aHnhKsJFvMwH5wIpiIiOzCHfL3Y9vl0Cg19jNQ=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2025.3.3.dmg";
      hash = "sha256-0aWVqcNHsGzawNmuNzbPZZxwIcOWK9zyULNIJDv7eHY=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2025.3.3-aarch64.dmg";
      hash = "sha256-v98kJnaxyAvo5aNgmgU4tR2BSR0etZgxxP9abJ6vBb4=";
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
  version = "2025.3.3";
  buildNumber = "253.31033.129";
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
