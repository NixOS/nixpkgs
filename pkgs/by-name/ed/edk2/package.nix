{ stdenv
, fetchFromGitHub
, fetchpatch
, applyPatches
, libuuid
, bc
, lib
, buildPackages
, nixosTests
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
else if stdenv.hostPlatform.isLoongArch64 then
  "LOONGARCH64"
else
  throw "Unsupported architecture";

buildType = if stdenv.isDarwin then
    "CLANGPDB"
  else
    "GCC5";

edk2 = stdenv.mkDerivation {
  pname = "edk2";
  version = "202408";

  srcWithVendoring = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2";
    rev = "edk2-stable${edk2.version}";
    fetchSubmodules = true;
    hash = "sha256-2odaTqiAZD5xduT0dwIYWj3gY/aFPVsTFbblIsEhBiA=";
  };

  src = applyPatches {
    name = "edk2-${edk2.version}-unvendored-src";
    src = edk2.srcWithVendoring;

    patches = [
      # pass targetPrefix as an env var
      (fetchpatch {
        url = "https://src.fedoraproject.org/rpms/edk2/raw/08f2354cd280b4ce5a7888aa85cf520e042955c3/f/0021-Tweak-the-tools_def-to-support-cross-compiling.patch";
        hash = "sha256-E1/fiFNVx0aB1kOej2DJ2DlBIs9tAAcxoedym2Zhjxw=";
      })
      # https://github.com/tianocore/edk2/pull/5658
      (fetchpatch {
        name = "fix-cross-compilation-antlr-dlg.patch";
        url = "https://github.com/tianocore/edk2/commit/a34ff4a8f69a7b8a52b9b299153a8fac702c7df1.patch";
        hash = "sha256-u+niqwjuLV5tNPykW4xhb7PW2XvUmXhx5uvftG1UIbU=";
      })
    ];

    postPatch = ''
      # We don't want EDK2 to keep track of OpenSSL, they're frankly bad at it.
      rm -r CryptoPkg/Library/OpensslLib/openssl
      mkdir -p CryptoPkg/Library/OpensslLib/openssl
      (
      cd CryptoPkg/Library/OpensslLib/openssl
      tar --strip-components=1 -xf ${buildPackages.openssl.src}

      # Apply OpenSSL patches.
      ${lib.pipe buildPackages.openssl.patches [
        (builtins.filter (
          patch:
          !builtins.elem (baseNameOf patch) [
            # Exclude patches not required in this context.
            "nix-ssl-cert-file.patch"
            "openssl-disable-kernel-detection.patch"
            "use-etc-ssl-certs-darwin.patch"
            "use-etc-ssl-certs.patch"
          ]
        ))
        (map (patch: "patch -p1 < ${patch}\n"))
        lib.concatStrings
      ]}
      )

      # enable compilation using Clang
      # https://bugzilla.tianocore.org/show_bug.cgi?id=4620
      substituteInPlace BaseTools/Conf/tools_def.template --replace-fail \
        'DEFINE CLANGPDB_WARNING_OVERRIDES    = ' \
        'DEFINE CLANGPDB_WARNING_OVERRIDES    = -Wno-unneeded-internal-declaration '
    '';
  };

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

  meta = {
    description = "Intel EFI development kit";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/EDK-II/";
    changelog = "https://github.com/tianocore/edk2/releases/tag/edk2-stable${edk2.version}";
    license = lib.licenses.bsd2;
    platforms = with lib.platforms; aarch64 ++ arm ++ i686 ++ x86_64 ++ loongarch64 ++ riscv64;
    maintainers = [ lib.maintainers.mjoerg ];
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
