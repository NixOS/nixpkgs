{
  pkgs,
  ...
}:
let
  libkrun = pkgs.libkrun.override {
    withNet = true;
    withBlk = true;
  };
in
pkgs.openshell.overrideAttrs (oldAttrs: {

  __structuredAttrs = true;

  nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
    pkgs.zstd
  ];

  preBuild = ''
    export OPENSHELL_VM_RUNTIME_COMPRESSED_DIR="$NIX_BUILD_TOP/compressed"
    mkdir -p "$OPENSHELL_VM_RUNTIME_COMPRESSED_DIR"
    zstd -cf ${pkgs.gvproxy}/bin/gvproxy > $OPENSHELL_VM_RUNTIME_COMPRESSED_DIR/gvproxy.zst
    zstd -cf ${pkgs.libkrunfw}/lib/libkrunfw.so.5 > $OPENSHELL_VM_RUNTIME_COMPRESSED_DIR/libkrunfw.so.5.zst
    zstd -cf ${libkrun}/lib/libkrun.so > $OPENSHELL_VM_RUNTIME_COMPRESSED_DIR/libkrun.so.zst
    zstd -cf ${pkgs.umoci}/bin/umoci > $OPENSHELL_VM_RUNTIME_COMPRESSED_DIR/umoci.zst
    zstd -cf ${pkgs.openshell}/bin/openshell-sandbox > $OPENSHELL_VM_RUNTIME_COMPRESSED_DIR/openshell-sandbox.zst
  '';

  # Tests are run as part of the openshell package already.
  doCheck = false;

  doInstallCheck = false;

  postPatch = ''
    # fill in package version to Cargo
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${pkgs.openshell.version}"'
    substituteInPlace Cargo.toml \
      --replace-fail 'members = ["crates/*"]' 'members = ["crates/openshell-driver-vm"]'
  '';

  meta.mainProgram = "openshell-vm-driver";
})
