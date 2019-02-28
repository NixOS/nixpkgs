{ stdenv, fetchFromGitHub, pkgconfig, sqlite, libyamlcpp, libuuid, gnome3, epoxy, librsvg, zeromq, cppzmq, glm, libgit2, curl, boost, python3, opencascade, wrapGAppsHook }:

stdenv.mkDerivation rec {
	name = "horizon-eda-${version}";
	version = "20190227";

	src = fetchFromGitHub {
		owner = "carrotIndustries";
		repo = "horizon";
		rev = "810fc8d1f59096ba3e1aac9d4b2187b1010b202a";
		sha256 = "0qxw3vsbf9cg6b3pp3z1k2fjl8xrnjdr2gcncnr5jzd1mix6yd4y";
	};

	# Version in specific format, created by: "git log -1 --pretty="format:%h %ci %s"
	patchPhase = ''
		mkdir .git && touch .git/HEAD && touch .git/index
		echo "const char *gitversion = \"810fc8d 2019-02-27 00:05:27 +0100 fix some includes\";" > src/gitversion.cpp
	'';

	buildInputs = [ pkgconfig sqlite libyamlcpp libuuid gnome3.gtkmm epoxy librsvg zeromq cppzmq glm libgit2 curl boost python3 opencascade ];

	nativeBuildInputs = [ wrapGAppsHook ];

	NIX_CFLAGS_COMPILE = "-I${opencascade}/include/oce";

	installPhase = ''
		mkdir -p $out/bin
		cp horizon-eda $out/bin/
		cp horizon-imp $out/bin/
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
