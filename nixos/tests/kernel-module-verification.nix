{
  lib,
  config,
  latestKernel,
  ...
}:

let
  test-module =
    {
      stdenv,
      kernel,
      kernelModuleMakeFlags,
    }:
    stdenv.mkDerivation {
      pname = "linux-test-module";
      inherit (kernel) version src;

      nativeBuildInputs = kernel.moduleBuildDependencies;

      makeFlags = [
        "-C"
        "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"

        "M=$(PWD)"
        "INSTALL_MOD_PATH=${placeholder "out"}"
        "DEPMOD=true"
      ]
      ++ kernelModuleMakeFlags;

      installTargets = [ "modules_install" ];

      preBuild = ''
        cd -- "$(mktemp -d)"
        cp "$NIX_BUILD_TOP/$sourceRoot/lib/test_module.c" .
        printf 'obj-m = test_module.o\n' > Kbuild
      '';

      strictDeps = true;

      __structuredAttrs = true;

      meta = {
        description = "Linux kernel test module";
        inherit (kernel.meta)
          license
          homepage
          platforms
          badPlatforms
          ;
        teams = [ lib.teams.boot-security ];
      };
    };
in

{
  _module.args.latestKernel = lib.mkDefault false;

  name = "kernel-module-verification";

  meta = {
    teams = [ lib.teams.boot-security ];
  };

  nodes.machine =
    {
      pkgs,
      config,
      ...
    }:
    {
      boot.kernelPackages = if latestKernel then pkgs.linuxPackages_latest else pkgs.linuxPackages;

      boot.kernelParams = [ "module.sig_enforce=1" ];

      boot.extraModulePackages = [
        (config.boot.kernelPackages.callPackage test-module { })
      ];
      boot.kernelModules = [ "test_module" ];

      system.systemBuilderCommands =
        let
          target =
            if pkgs.stdenv.hostPlatform.isAarch64 then
              "vmlinuz.efi"
            else
              config.boot.kernelPackages.kernel.target;
          finalKernel = config.boot.kernelPackages.rebuildImage {
            inherit target;
            inherit (config.system) modulesTree;
          };
          kernelPath = "${finalKernel}/${target}";
        in
        lib.mkAfter ''
          ln -sf -- ${lib.escapeShellArg kernelPath} $out/kernel
        '';
    };

  testScript = ''
    machine.succeed("journalctl --dmesg --grep='^test_module: Hello, world$'")
  '';
}
