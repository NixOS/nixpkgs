{platform ? __currentSystem} : 
let 
  isoFun = import ./rescue-cd-configurable.nix;
in 
(isoFun {
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
	includeBuildDeps = true;
}).rescueCD
