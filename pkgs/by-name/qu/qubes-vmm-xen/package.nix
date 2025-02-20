{
  lib,
  fetchpatch,
  buildXenPackage,
  qubes-seabios,
  xen,
}:

let
  version = "4.19.0";
  upstreamVersion = version;
  revision = "5";

  qubesPatches = import ./patches.nix {
    inherit fetchpatch version revision;
  };
  qubesPatchList = lib.lists.flatten (
    with qubesPatches;
    [
      EFI_WORKAROUNDS
      BACKPORTS
      SECURITY_FIXES
      UPSTREAMABLE_PATCHES
      S0IX_SUPPORT
      QUBES_SPECIFIC_PATCHES
      REPRODUCIBLE_BUILDS
      GVT-G
    ]
  );
in

buildXenPackage.override { systemSeaBIOS = qubes-seabios; } {
  pname = "qubes-vmm-xen";
  inherit version upstreamVersion;
  vendor = "qubes";

  withSeaBIOS = true;
  withOVMF = true;
  withIPXE = false;

  rev = "026c9fa29716b0ff0f8b7c687908e71ba29cf239";
  hash = "sha256-Q6x+2fZ4ITBz6sKICI0NHGx773Rc919cl+wzI89UY+Q=";
  patches = qubesPatchList;

  meta = {
    inherit (xen.meta) license mainProgram platforms;
    description = "Qubes component: `vmm-xen`";
    longDescription = ''
      Qubes OS' modified version of the Xen Project Hypervisor.
      Contains dozens of Qubes-specific patches, and is intended to power a Qubes OS Domain 0.
    '';
    homepage = "https://qubes-os.org";
    downloadPage = "https://github.com/QubesOS/qubes-vmm-xen";
    maintainers = with lib.maintainers; [
      lach
      sigmasquadron
    ];
  };
}
