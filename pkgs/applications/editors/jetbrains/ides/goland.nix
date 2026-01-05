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
      url = "https://download.jetbrains.com/go/goland-2025.3.tar.gz";
      hash = "sha256-YVGFYobqVG64r5rrAldyzua9VxNPRUlKgY6NogqGkcY=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/go/goland-2025.3-aarch64.tar.gz";
      hash = "sha256-xTDdS8x6B1oEC2SFnss0FCyPwDmWJcWhOuLXqPWXQ0A=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2025.3.dmg";
      hash = "sha256-4d9PELFYx3iHNlWWZiROmUUApA21sIZh4mkTV9Jp2/Q=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/go/goland-2025.3-aarch64.dmg";
      hash = "sha256-1O4gtcPfYVHTZtbMmwa5FUmf8MHrEYSqtToBB4kI7Ik=";
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
  version = "2025.3";
  buildNumber = "253.28294.337";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  extraWrapperArgs = [
    # fortify source breaks build since delve compiles with -O0
    ''--prefix CGO_CPPFLAGS " " "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0"''
  ];
  buildInputs = [
    libgcc
  ];

  # NOTE: meta attrs are currently used by the desktop entry, so changing them may cause rebuilds (see TODO in README)
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
