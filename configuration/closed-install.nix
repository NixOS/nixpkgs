{
	platform ? __currentSystem
	,hostConnectPort ? "3737"
} : 
let 
  isoFun = import ./rescue-cd-configurable.nix;
in 
(isoFun {
	inherit platform;

	networkNixpkgs = "";
	manualEnabled = true;
	rogueEnabled = false;
	sshdEnabled = true;
	fontConfigEnabled = false;
	sudoEnable = true;
	includeMemtest = false;
	includeStdenv = true;
	includeBuildDeps = true;

	/*
		If anyone uses that DVD on live
		computer, use DHCP; but also add
		a rogue address for tests in virtual
		networks without DHCP at all.
	*/
	addIP = "10.0.253.251";
	netmask = "255.255.0.0";

	packages = pkgs : [
		pkgs.patch
		pkgs.irssi
		pkgs.subversion
		pkgs.w3m
		pkgs.utillinuxCurses
		pkgs.wpa_supplicant
		pkgs.emacs
		pkgs.vimHugeX
		pkgs.socat
	];

	/* 
		The goal is remotely controlled 
		installation (maybe over virtual
		networking with QEmu without human
		interaction), so let's make ssh 
		work without manual password entry
	*/
	additionalFiles = [
		{
			source = /var/certs/ssh/id_livedvd.pub;
			target = "/root/.ssh/authorized_keys";
		}
	];

	additionalJobs = [
		{
			name = "Socat-ssh-proxy";
			job = ''
				start on sshd/started
				script
					sleep 5
					/var/run/current-system/sw/bin/socat tcp:10.0.2.2:${hostConnectPort} tcp:127.0.0.1:22
				end script
			'';
		}
	];
}).rescueCD
