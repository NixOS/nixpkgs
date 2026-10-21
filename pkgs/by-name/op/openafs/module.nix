{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  kernelModuleInstallHook,
  which,
  autoconf,
  automake,
  flex,
  bison,
  kernel,
  glibc,
  perl,
  libtool_2,
  libkrb5,
}:

let
  inherit (import ./srcs.nix { inherit fetchurl; }) src version;

  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

in
stdenv.mkDerivation {
  pname = "openafs";
  version = "${version}-${kernel.modDirVersion}";
  inherit src;

  patches = [
    # LINUX: Disable osi_dnlc
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16927/revisions/a3bd427be8437a38c96ac34ef8216e58ab999945/patch";
      hash = "sha256-q0AOGpWL1r2hMLQgowMBkfOcEvhXEhXVLe1A/tlawFo=";
      decode = "base64 -d";
    })
    # linux: replace strncpy with strscpy
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/16928/revisions/5f04ae748a1ede14882174a81dfa38baa2e66a20/patch";
      hash = "sha256-fwzRzS799Y68l29vlzIAmHLda57gToLippgNMKWfWaw=";
      decode = "base64 -d";
    })
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [
    autoconf
    automake
    flex
    kernelModuleInstallHook
    libtool_2
    perl
    which
    bison
  ];

  buildInputs = [ libkrb5 ];

  hardeningDisable = [ "pic" ];

  configureFlags = [
    "--with-linux-kernel-build=${kernelBuildDir}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gssapi"
  ];

  preConfigure = ''
    patchShebangs .
    for i in `grep -l -R '/usr/\(include\|src\)' .`; do
      echo "Patch /usr/include and /usr/src in $i"
      substituteInPlace $i \
        --replace "/usr/include" "${glibc.dev}/include" \
        --replace "/usr/src" "${kernelBuildDir}"
    done

    ./regen.sh -q
  '';

  buildPhase = ''
    make V=1 only_libafs
  '';

  kernelModuleDirs = [ "src/libafs/MODLOAD-${kernel.modDirVersion}-MP" ];
  kernelModuleInstallDir = "extra/openafs";

  meta = {
    description = "Open AFS client kernel module";
    homepage = "https://www.openafs.org";
    license = lib.licenses.ipl10;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      andersk
      spacefrogg
    ];
  };
}
