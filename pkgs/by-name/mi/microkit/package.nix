{
  fetchurl,
  lib,
  stdenvNoCC,
}:

let
  version = "2.3.0";

  sources = {
    "x86_64-linux" = {
      url = "https://github.com/seL4/microkit/releases/download/${version}/microkit-sdk-${version}-linux-x86-64.tar.gz";
      hash = "sha256-4S5Qf3LIfL9cUU356bDGYQO0IpiFL0TARdVynqPeT4k=";
    };
    "aarch64-linux" = {
      url = "https://github.com/seL4/microkit/releases/download/${version}/microkit-sdk-${version}-linux-aarch64.tar.gz";
      hash = "sha256-mKGL1dkDhsenKlQQg6jhoxKa6DvyfXHGV1mzY0RxiEE=";
    };
  };

  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "microkit: unsupported platform ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "microkit";
  inherit version;

  src = fetchurl {
    inherit (source) url hash;
  };

  __structuredAttrs = true;
  strictDeps = true;

  # bin/microkit is a static-pie executable. The ELF files under board/ are
  # inputs the tool reads symbols from, not executables of this package.
  dontPatchELF = true;
  dontStrip = true;

  # The SDK is used as one tree: build systems point MICROKIT_SDK at its root
  # and reach board/<board>/<config>/{include,lib,elf} from there.
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r . $out/
    chmod +x $out/bin/microkit

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/microkit --help > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "SDK for the seL4 Microkit operating system framework";
    longDescription = ''
      The seL4 Microkit is a framework for writing statically structured
      systems on the seL4 microkernel. The SDK contains the microkit tool,
      which turns a system description and a set of ELF files into a bootable
      image, along with the seL4 kernel, libmicrokit and the linker scripts
      for every supported board and build configuration.

      Build systems locate the rest of the SDK through the MICROKIT_SDK
      environment variable, which should point at this package's root.
    '';
    homepage = "https://docs.sel4.systems/projects/microkit/";
    changelog = "https://github.com/seL4/microkit/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    mainProgram = "microkit";
    maintainers = with lib.maintainers; [ conao3 ];
    platforms = lib.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
