{ stdenv, fetchFromGitHub, pkgconfig, sqlite, libyamlcpp, libuuid, gnome3, epoxy, librsvg, zeromq, cppzmq, glm, libgit2, curl, boost, python3, opencascade, libzip, podofo, wrapGAppsHook }:

stdenv.mkDerivation rec {
	pname = "horizon-eda";
	version = "1.0.0";

	src = fetchFromGitHub {
		owner = "horizon-eda";
		repo = "horizon";
		rev = "3f777bd2501b953981d64cf2054c265ce8d65c02";
		sha256 = "1d40lfgylwl3srqazyjgw9l3n7i82xrvkjcxvpx7ddyzy1d2aqmr";
	};

	buildInputs = [ sqlite libyamlcpp libuuid gnome3.gtkmm epoxy librsvg zeromq cppzmq glm libgit2 curl boost python3 libzip podofo opencascade ];

	nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

	NIX_CFLAGS_COMPILE = "-I${opencascade}/include/oce";

	installPhase = ''
		mkdir -p $out/bin
		cp build/horizon-eda $out/bin/
		cp build/horizon-imp $out/bin/
	'';

	enableParallelBuilding = true;

	meta = with stdenv.lib; {
		description = "A free EDA software to develop printed circuit boards";
		homepage = "https://github.com/horizon-eda/horizon";
		maintainers = with maintainers; [ luz ];
		license = licenses.gpl3;
		platforms = platforms.linux;
	};
}
