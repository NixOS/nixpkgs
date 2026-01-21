# TODO there should probably be a generic mechanism to patch any in-kernel module like this
{
  stdenv,
  kernel, # The kernel to patch
  patches ? [ ],
}:

stdenv.mkDerivation {
  pname = "amdgpu-kernel-module-customised";
  inherit (kernel)
    src
    version
    postPatch
    nativeBuildInputs
    modDirVersion
    ;
  patches = kernel.patches or [ ] ++ patches;

  modulePath = "drivers/gpu/drm/amd/amdgpu";

  buildPhase = ''
    BUILT_KERNEL=${kernel.dev}/lib/modules/$modDirVersion/build

    cp $BUILT_KERNEL/Module.symvers $BUILT_KERNEL/.config ${kernel.dev}/vmlinux ./

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M=$modulePath modules
  '';

  installPhase = ''
    make \
      INSTALL_MOD_PATH="$out" \
      XZ="xz -T$NIX_BUILD_CORES" \
      M="$modulePath" \
      modules_install
  '';

  meta = {
    description = "AMDGPU kernel module";
    inherit (kernel.meta) license;
  };
}
