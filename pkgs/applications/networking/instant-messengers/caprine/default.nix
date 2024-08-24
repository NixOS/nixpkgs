{ lib
, stdenv
, fetchFromGitHub
, electron
, buildNpmPackage
, makeDesktopItem
, copyDesktopItems
}:

buildNpmPackage rec {
	pname = "Caprine";
	version = "2.60.1";
	src = fetchFromGitHub {
		owner = "sindresorhus";
		repo = "caprine";
		rev = "v${version}";
		sha256 = "sha256-y4W295i7FhgJC3SlwSr801fLOGJY1WF136bbkkBUvyw=";
	};
	
	npmDepsHash = "sha256-JHaUc2p+wHsqWtls8xquHK9qnypuCrR0AQMGxcrTsC0=";	

	ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

	nativeBuildInputs = [ copyDesktopItems ];

	postBuild = ''
		npm exec electron-builder -- \
		--dir \
		--linux \
		-c.electronDist=${electron}/libexec/electron \
		-c.electronVersion=${electron.version}
	'';

	installPhase = ''
		runHook preInstall

		mkdir -p $out/share/lib/caprine $out/bin		
		cp -r dist/linux*-unpacked/{locales,resources{,.pak}} $out/share/lib/caprine
		makeWrapper '${electron}/bin/electron' "$out/bin/caprine" \
			--add-flags $out/share/lib/caprine/resources/app.asar \
			--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
			--inherit-argv0
		
		for s in 16 32 48 64 128 256 512; do
			size=${"$"}{s}x$s
			install -Dm644 $src/build/icons/$size.png $out/share/icons/hicolor/$size/apps/caprine.png
		done

		runHook postInstall
	'';

	desktopItems = [
		(makeDesktopItem {
		name = "caprine";
		exec = "caprine %U";
		icon = "caprine";
		desktopName = "Caprine";
		comment = meta.description;
		categories = [ "Network" "Chat" ];
		startupWMClass = "Caprine";
		})
	];


	meta = with lib; {
		description = "An elegant Facebook Messenger desktop app";
		homepage = "https://sindresorhus.com/caprine";
		license = licenses.mit;
		maintainers = with maintainers; [ dxwil ];
		inherit (electron.meta) platforms;
		mainProgram = "caprine";
	};
}
