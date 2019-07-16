{ stdenv, fetchFromGitHub, pkgconfig, sqlite, libyamlcpp, libuuid, gnome3, epoxy, librsvg, zeromq, cppzmq, glm, libgit2, curl, boost, python3, opencascade, libzip, podofo, wrapGAppsHook }:

stdenv.mkDerivation rec {
	name = "horizon-eda-${version}";
	version = "20190716";

	src = fetchFromGitHub {
		owner = "carrotIndustries";
		repo = "horizon";
		rev = "85c171a3dc29d6cab41f5effd230d1769e519b4d";
		sha256 = "012vi91bxzbvabg6v2ldl916jg24i6pc9lpnniwq3c2pzpvlvndg";
	};

	patchPhase = ''
		echo "const char *gitversion = \"${src.rev}\";" > src/gitversion.cpp
	'';

	buildInputs = [ pkgconfig sqlite libyamlcpp libuuid gnome3.gtkmm epoxy librsvg zeromq cppzmq glm libgit2 curl boost python3 libzip podofo opencascade ];

	nativeBuildInputs = [ wrapGAppsHook ];

	NIX_CFLAGS_COMPILE = "-I${opencascade}/include/oce";

	installPhase = ''
		mkdir -p $out/bin
		cp build/horizon-eda $out/bin/
		cp build/horizon-imp $out/bin/
	'';

	preFixup = ''
		wrapProgram "$out/bin/horizon-eda" "''${gappsWrapperArgs[@]}"
	'';

	enableParallelBuilding = true;

	meta = with stdenv.lib; {
		description = "A free EDA software to develop printed circuit boards";
		homepage = https://github.com/carrotIndustries/horizon;
		maintainers = with maintainers; [ luz ];
		license = licenses.gpl3;
		platforms = platforms.linux;
	};
}
