{ stdenv
, fetchFromGitHub
, fetchpatch
, libuuid
, bc
, lib
, buildPackages
, nixosTests
, runCommand
, writeScript
}:

let
  pythonEnv = buildPackages.python3.withPackages (ps: [ps.tkinter]);

targetArch = if stdenv.isi686 then
  "IA32"
else if stdenv.isx86_64 then
  "X64"
else if stdenv.isAarch32 then
  "ARM"
else if stdenv.isAarch64 then
  "AARCH64"
else if stdenv.hostPlatform.isRiscV64 then
  "RISCV64"
else
  throw "Unsupported architecture";

buildType = if stdenv.isDarwin then
    "CLANGPDB"
  else
    "GCC5";

edk2 = stdenv.mkDerivation rec {
  pname = "edk2";
  version = "202402";

  patches = [
    # pass targetPrefix as an env var
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/edk2/raw/08f2354cd280b4ce5a7888aa85cf520e042955c3/f/0021-Tweak-the-tools_def-to-support-cross-compiling.patch";
      hash = "sha256-E1/fiFNVx0aB1kOej2DJ2DlBIs9tAAcxoedym2Zhjxw=";
    })
    # https://github.com/tianocore/edk2/pull/5658
    (fetchpatch {
      url = "https://github.com/tianocore/edk2/commit/a34ff4a8f69a7b8a52b9b299153a8fac702c7df1.patch";
      hash = "sha256-u+niqwjuLV5tNPykW4xhb7PW2XvUmXhx5uvftG1UIbU=";
    })
  ];

  srcWithVendoring = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2";
    rev = "edk2-stable${edk2.version}";
    fetchSubmodules = true;
    hash = "sha256-Nurm6QNKCyV6wvbj0ELdYAL7mbZ0yg/tTwnEJ+N18ng=";
  };

  # We don't want EDK2 to keep track of OpenSSL,
  # they're frankly bad at it.
  src = runCommand "edk2-unvendored-src" { } ''
    cp --no-preserve=mode -r ${srcWithVendoring} $out
    rm -rf $out/CryptoPkg/Library/OpensslLib/openssl
    mkdir -p $out/CryptoPkg/Library/OpensslLib/openssl
    tar --strip-components=1 -xf ${buildPackages.openssl.src} -C $out/CryptoPkg/Library/OpensslLib/openssl
    chmod -R +w $out/

    # Fix missing INT64_MAX include that edk2 explicitly does not provide
    # via it's own <stdint.h>. Let's pull in openssl's definition instead:
    sed -i $out/CryptoPkg/Library/OpensslLib/openssl/crypto/property/property_parse.c \
        -e '1i #include "internal/numbers.h"'
  '';

  nativeBuildInputs = [ pythonEnv ];
  depsBuildBuild = [ buildPackages.stdenv.cc buildPackages.bash ];
  depsHostHost = [ libuuid ];
  strictDeps = true;

  # trick taken from https://src.fedoraproject.org/rpms/edk2/blob/08f2354cd280b4ce5a7888aa85cf520e042955c3/f/edk2.spec#_319
  ${"GCC5_${targetArch}_PREFIX"} = stdenv.cc.targetPrefix;

  makeFlags = [ "-C BaseTools" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-return-type"
    + lib.optionalString (stdenv.cc.isGNU) " -Wno-error=stringop-truncation"
    + lib.optionalString (stdenv.isDarwin) " -Wno-error=macro-redefined";

  hardeningDisable = [ "format" "fortify" ];

  installPhase = ''
    mkdir -vp $out
    mv -v BaseTools $out
    mv -v edksetup.sh $out
    # patchShebangs fails to see these when cross compiling
    for i in $out/BaseTools/BinWrappers/PosixLike/*; do
      chmod +x "$i"
      patchShebangs --build "$i"
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Intel EFI development kit";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/EDK-II/";
    changelog = "https://github.com/tianocore/edk2/releases/tag/edk2-stable${edk2.version}";
    license = licenses.bsd2;
    platforms = with platforms; aarch64 ++ arm ++ i686 ++ x86_64 ++ riscv64;
  };

  passthru = {
    # exercise a channel blocker
    tests.uefiUsb = nixosTests.boot.uefiCdrom;

    updateScript = writeScript "update-edk2" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts coreutils gnused
      set -eu -o pipefail
      version="$(list-git-tags --url="${edk2.srcWithVendoring.url}" |
                 sed -E --quiet 's/^edk2-stable([0-9]{6})$/\1/p' |
                 sort --reverse --numeric-sort |
                 head -n 1)"
      if [[ "x$UPDATE_NIX_OLD_VERSION" != "x$version" ]]; then
          update-source-version --source-key=srcWithVendoring \
              "$UPDATE_NIX_ATTR_PATH" "$version"
      fi
    '';

    mkDerivation = projectDscPath: attrsOrFun: stdenv.mkDerivation (finalAttrs:
    let
      attrs = lib.toFunction attrsOrFun finalAttrs;
    in
    {
      inherit (edk2) src;

      depsBuildBuild = [ buildPackages.stdenv.cc ] ++ attrs.depsBuildBuild or [];
      nativeBuildInputs = [ bc pythonEnv ] ++ attrs.nativeBuildInputs or [];
      strictDeps = true;

      ${"GCC5_${targetArch}_PREFIX"}=stdenv.cc.targetPrefix;

      prePatch = ''
        rm -rf BaseTools
        ln -sv ${buildPackages.edk2}/BaseTools BaseTools
      '';

      configurePhase = ''
        runHook preConfigure
        export WORKSPACE="$PWD"
        . ${buildPackages.edk2}/edksetup.sh BaseTools
        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild
        build -a ${targetArch} -b ${attrs.buildConfig or "RELEASE"} -t ${buildType} -p ${projectDscPath} -n $NIX_BUILD_CORES $buildFlags
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mv -v Build/*/* $out
        runHook postInstall
      '';
    } // removeAttrs attrs [ "nativeBuildInputs" "depsBuildBuild" ]);
  };
};

in

edk2
