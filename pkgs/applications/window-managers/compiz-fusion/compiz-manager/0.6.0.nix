args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
	fetchurl {
		url = http://releases.compiz-fusion.org/0.6.0/compiz-manager-0.6.0.tar.bz2;
		sha256 = "0bjl0kwzl4mc9nw2id8z5q5ikgm8c5zrknn9nm851if005479q3v";
	};
		buildInputs = (import ../general-dependencies.nix args) ++
			[bcop ccsm xvinfo glxinfo xdpyinfo ];
		shellReplacements = ["compiz-manager" [
			"COMPIZ_BIN_PATH" "${compiz}/bin/"
			"PLUGIN_PATH" "/var/run/current-system/sw/share/compiz-plugins/compiz/"
			"GLXINFO" "${glxinfo}/bin/glxinfo"
			"KWIN" "/var/run/current-system/sws/bin/kwin"
			"METACITY" "/var/run/current-system/sws/bin/metacity"
			"COMPIZ_NAME" "compiz"
			"FALLBACKWM" "'\''\"\${KWIN}\"'\''"
			"WHITELIST" "nvidia intel ati radeon i810 i830 i915"
			"INDIRECT" "yes"
			"XORG_DRIVER_PATH" "/nix/store/.*"
		]];
	};
	in with localDefs;
let
	install = FullDepEntry ("
		sed -e '/Checking for texture_from_pixmap:/areturn 0' -i compiz-manager
		sed -e '/Checking for non power of two support: /areturn 0' -i compiz-manager
		sed -e '/^\s*$/aPATH=\$PATH:${xvinfo}/bin:${xdpyinfo}/bin' -i compiz-manager

		ensureDir \$out/bin
		cp compiz-manager \$out/bin
	") 
	[minInit doUnpack defEnsureDir];
in
stdenv.mkDerivation rec {
	name = "compiz-manager-"+args.version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doUnpack doReplaceScripts install doPropagate doForceShare]);
	meta = {
		description = "
	Compiz Launch Manager
";
		inherit src;
	};
}
