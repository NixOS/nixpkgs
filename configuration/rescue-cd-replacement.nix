{platform ? __currentSystem} : 
let 
  isoFun = import ./rescue-cd-configurable.nix;
in (isoFun {
   inherit platform;
   lib = (import ../pkgs/lib);

   networkNixpkgs = "";
   manualEnabled = false;
   rogueEnabled = false;
   sshdEnabled = false;
   fontConfigEnabled = false;
   sudoEnable = false;
   includeMemtest = false;
   includeStdenv = false;
   includeBuildDeps = false;

   extraInitrdKernelModules = 
     import ./moduleList.nix;
  packages = pkgs: [
    pkgs.vim
    pkgs.subversion # for nixos-checkout
    pkgs.w3m # needed for the manual anyway
    pkgs.gdb # for debugging Nix
    pkgs.testdisk # useful for repairing boot problems
    pkgs.mssys # for writing Microsoft boot sectors / MBRs
  ];

}).rescueCD
