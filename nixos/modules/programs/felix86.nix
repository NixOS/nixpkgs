{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.felix86;

  package-wrapped = pkgs.symlinkJoin {
    name = "felix86";
    paths = [ cfg.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/felix86 \
      --set-default FELIX86_ROOTFS ${lib.escapeShellArg cfg.rootfs}
    '';
  };
in

{
  options.programs.felix86 = {
    enable = lib.mkEnableOption "felix86 x86/x86-64 userspace emulator";
    package = lib.mkPackageOption pkgs "felix86" { };

    rootfs = lib.mkOption {
      type = lib.types.path;
      example = "/opt/felix86/rootfs";
      description = "Path to the rootfs for felix86.";
    };

    # TODO: only for testing. remove later
    disableBinfmt = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Avoid cyclic dependency between Linux and RISC-V emulation";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # package-wrapped
      cfg.package
    ];

    # register binfmt_misc for transparent x86/x86-64 execution
    boot.binfmt.registrations =
      let
        commonOptions = {
          interpreter = "${cfg.package}/bin/felix86";

          # https://www.kernel.org/doc/html/latest/admin-guide/binfmt-misc.html
          openBinary = true;
          matchCredentials = true;
          fixBinary = true;
          wrapInterpreterInShell = false;
        };
      in
      lib.mkIf (!cfg.disableBinfmt) {
        felix86-x86_64 = commonOptions // {
          magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
          mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\x00\x00\x00\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
        };

        felix86-i386 = commonOptions // {
          magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'';
          mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\x00\x00\x00\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
        };
      };
  };
}
