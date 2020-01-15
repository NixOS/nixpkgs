{ stdenv, lib, fetchurl, buildFHSUserEnv, makeDesktopItem, makeWrapper, atomEnv, libuuid, at-spi2-atk, icu, openssl, zlib }:
	let
		pname = "sidequest";
		version = "0.3.1";
		
		desktopItem = makeDesktopItem rec {
			name = "SideQuest";
			exec = "SideQuest";
			desktopName = name;
			genericName = "VR App Store";
			categories = "Settings;PackageManager;";
		};

		sidequest = stdenv.mkDerivation {
			inherit pname version;

			src = fetchurl {
				url = "https://github.com/the-expanse/SideQuest/releases/download/${version}/SideQuest-linux-x64.tar.gz";
				sha256 = "1hj398zzp1x74zhp9rlhqzm9a0ck6zh9bj39g6fpvc38zab5dj1p";
			};

			buildInputs = [ makeWrapper ];

			buildCommand = ''
				mkdir -p "$out/lib/SideQuest" "$out/bin"
				tar -xzf "$src" -C "$out/lib/SideQuest" --strip-components 1

				ln -s "$out/lib/SideQuest/SideQuest" "$out/bin"

				fixupPhase

				# mkdir -p "$out/share/applications"
				# ln -s "${desktopItem}/share/applications/*" "$out/share/applications"

				patchelf \
					--set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
					--set-rpath "${atomEnv.libPath}/lib:${lib.makeLibraryPath [libuuid at-spi2-atk]}:$out/lib/SideQuest" \
					"$out/lib/SideQuest/SideQuest"
			'';
		};
	in buildFHSUserEnv {
		name = "SideQuest";

		passthru = {
			inherit pname version;

			meta = with stdenv.lib; {
				description = "An open app store and side-loading tool for Android-based VR devices such as the Oculus Go, Oculus Quest or Moverio BT 300";
				homepage = "https://github.com/the-expanse/SideQuest";
				downloadPage = "https://github.com/the-expanse/SideQuest/releases";
				license = licenses.mit;
				maintainers = [ maintainers.joepie91 ];
				platforms = [ "x86_64-linux" ];
			};
		};
		
		targetPkgs = pkgs: [
			sidequest
			# Needed in the environment on runtime, to make QuestSaberPatch work
			icu openssl zlib
		];

		extraInstallCommands = ''
			mkdir -p "$out/share/applications"
			ln -s "${desktopItem}/share/applications/*" "$out/share/applications"
		'';

		runScript = "SideQuest";
	}
