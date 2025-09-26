{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  applyPatches,
  libuuid,
  bc,
  lib,
  buildPackages,
  nixosTests,
  writeScript,
}:

let
  pythonEnv = buildPackages.python3.withPackages (ps: [ ps.tkinter ]);

  targetArch =
    if stdenv.hostPlatform.isi686 then
      "IA32"
    else if stdenv.hostPlatform.isx86_64 then
      "X64"
    else if stdenv.hostPlatform.isAarch32 then
      "ARM"
    else if stdenv.hostPlatform.isAarch64 then
      "AARCH64"
    else if stdenv.hostPlatform.isRiscV64 then
      "RISCV64"
    else if stdenv.hostPlatform.isLoongArch64 then
      "LOONGARCH64"
    else
      throw "Unsupported architecture";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "edk2";
  version = "202508";

  srcWithVendoring = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2";
    tag = "edk2-stable${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-YZcjPGPkUQ9CeJS9JxdHBmpdHsAj7T0ifSZWZKyNPMk=";
  };

  src = applyPatches {
    name = "edk2-${finalAttrs.version}-unvendored-src";
    src = finalAttrs.srcWithVendoring;

    patches = [
      # pass targetPrefix as an env var
      (fetchpatch {
        url = "https://src.fedoraproject.org/rpms/edk2/raw/08f2354cd280b4ce5a7888aa85cf520e042955c3/f/0021-Tweak-the-tools_def-to-support-cross-compiling.patch";
        hash = "sha256-E1/fiFNVx0aB1kOej2DJ2DlBIs9tAAcxoedym2Zhjxw=";
      })

      ./fix-cross-compilation-antlr-dlg.patch
    ];

    # FIXME: unvendor OpenSSL again once upstream updates
    # to a compatible version.
    # Upstream PR: https://github.com/tianocore/edk2/pull/10946
    postPatch = ''
      # enable compilation using Clang
      # https://bugzilla.tianocore.org/show_bug.cgi?id=4620
      substituteInPlace BaseTools/Conf/tools_def.template --replace-fail \
        'DEFINE CLANGPDB_WARNING_OVERRIDES    = ' \
        'DEFINE CLANGPDB_WARNING_OVERRIDES    = -Wno-unneeded-internal-declaration '
    '';
  };

  nativeBuildInputs = [ pythonEnv ];
  depsBuildBuild = [
    buildPackages.stdenv.cc
    buildPackages.bash
  ];
  depsHostHost = [ libuuid ];
  strictDeps = true;

  # trick taken from https://src.fedoraproject.org/rpms/edk2/blob/08f2354cd280b4ce5a7888aa85cf520e042955c3/f/edk2.spec#_319
  ${"GCC5_${targetArch}_PREFIX"} = stdenv.cc.targetPrefix;

  makeFlags = [ "-C BaseTools" ];

  env = {
    NIX_CFLAGS_COMPILE =
      "-Wno-return-type"
      + lib.optionalString (stdenv.cc.isGNU) " -Wno-error=stringop-truncation"
      + lib.optionalString (stdenv.hostPlatform.isDarwin) " -Wno-error=macro-redefined";
    PYTHON_COMMAND = lib.getExe pythonEnv;
  };

  hardeningDisable = [
    "format"
    "fortify"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -vp $out
    mv -v BaseTools $out
    mv -v edksetup.sh $out
    # patchShebangs fails to see these when cross compiling
    for i in $out/BaseTools/BinWrappers/PosixLike/*; do
      chmod +x "$i"
      patchShebangs --build "$i"
    done

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Intel EFI development kit";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/EDK-II/";
    changelog = "https://github.com/tianocore/edk2/releases/tag/edk2-stable${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = with lib.platforms; aarch64 ++ arm ++ i686 ++ x86_64 ++ loongarch64 ++ riscv64;
    maintainers = [ lib.maintainers.mjoerg ];
  };

  passthru = {
    # exercise a channel blocker
    tests = {
      systemdBootExtraEntries = nixosTests.systemd-boot.extraEntries;
      uefiUsb = nixosTests.boot.uefiCdrom;
    };

    updateScript = writeScript "update-edk2" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts coreutils gnused
      set -eu -o pipefail
      version="$(list-git-tags --url="${finalAttrs.srcWithVendoring.url}" |
                 sed -E --quiet 's/^edk2-stable([0-9]{6})$/\1/p' |
                 sort --reverse --numeric-sort |
                 head -n 1)"
      if [[ "x$UPDATE_NIX_OLD_VERSION" != "x$version" ]]; then
          update-source-version --source-key=srcWithVendoring \
              "$UPDATE_NIX_ATTR_PATH" "$version"
      fi
    '';

    mkDerivation =
      projectDscPath: attrsOrFun:
      stdenv.mkDerivation (
        finalAttrsInner:
        let
          attrs = lib.toFunction attrsOrFun finalAttrsInner;
          buildType = attrs.buildType or (if stdenv.hostPlatform.isDarwin then "CLANGPDB" else "GCC5");
        in
        {
          inherit (finalAttrs) src;

          depsBuildBuild = [ buildPackages.stdenv.cc ] ++ attrs.depsBuildBuild or [ ];
          nativeBuildInputs = [
            bc
            pythonEnv
          ]
          ++ attrs.nativeBuildInputs or [ ];
          strictDeps = true;

          ${"GCC5_${targetArch}_PREFIX"} = stdenv.cc.targetPrefix;

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
        }
        // removeAttrs attrs [
          "nativeBuildInputs"
          "depsBuildBuild"
        ]
      );
  };
})
