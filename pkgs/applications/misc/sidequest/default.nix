{ stdenv, lib, fetchurl, buildFHSUserEnv, makeDesktopItem, wrapGAppsHook, atomEnv, libuuid, at-spi2-atk, icu, openssl, zlib, gtk3 }:
	let
		pname = "sidequest";
		version = "0.10.4";

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
				url = "https://github.com/the-expanse/SideQuest/releases/download/v${version}/SideQuest-${version}.tar.xz";
				sha256 = "1hd5093rn3y2l3gibzbylwbl0i4zh80a9bf1wb11jfv07x8n93cp";
			};

			buildInputs = [ gtk3 ];
			nativeBuildInputs = [ wrapGAppsHook ];

			installPhase = ''
				mkdir -p "$out/lib/SideQuest" "$out/bin"
				cp -r . "$out/lib/SideQuest"

				ln -s "$out/lib/SideQuest/sidequest" "$out/bin"
			'';

			postFixup = ''
				# mkdir -p "$out/share/applications"
				# ln -s "${desktopItem}/share/applications/*" "$out/share/applications"

				patchelf \
					--set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
					--set-rpath "${atomEnv.libPath}/lib:${lib.makeLibraryPath [libuuid at-spi2-atk]}:$out/lib/SideQuest" \
					"$out/lib/SideQuest/sidequest"
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
				maintainers = with maintainers; [ joepie91 rvolosatovs ];
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
			ln -s ${desktopItem}/share/applications/* "$out/share/applications"
		'';

		runScript = "sidequest";
	}
