{ 
	libXrender, 
	libXrandr, 
	libXcursor, 
	libX11, 
	libXext, 
	libXi, 
	libxcb,
	cups,
	gcc-unwrapped,
	lib,
	glibc,
	libstdcxx5,
	mesa,
	libGL,
	nss,
	libdrm,
	libatomic_ops, 
	libnsl       , 
	libgcc       , 
	gcc,
	rpmextract   , 
	alsaLib      , 
	stdenv       , 
	fetchurl     , 
	autoPatchelfHook, 
	wrapGAppsHook, 
	dpkg         , 
	libuuid      , 
	pulseaudio   , 
	at-spi2-atk  , 
	coreutils    , 
	gawk         , 
	xdg_utils    , 
	systemd ,
}:   

stdenv.mkDerivation rec {
	pname = "edge";
	version = "dev";

  //https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-dev/microsoft-edge-dev_88.0.673.0-1_amd64.deb
  //sha256: 1qfk2jhs512yq52ix7y16np4xiv0xi5nxmcbchilzddz6b105l7z
	src = ./microsoft-edge-dev_88.0.673.0-1_amd64.deb;
	nativeBuildInputs = [ dpkg rpmextract autoPatchelfHook wrapGAppsHook ];
	buildInputs = [ 
		glibc
		gcc-unwrapped.lib
		libstdcxx5
		cups
		libXrender  libXrandr  libXcursor  libX11  libXext  libXi  libxcb 
		mesa
		libGL
		nss
		libdrm
		alsaLib 
		libnsl
		libuuid
		at-spi2-atk
		libatomic_ops
		libgcc
		gcc
	];

	unpackPhase = "dpkg --fsys-tarfile ${src} | tar -x --no-same-permissions --no-same-owner";

	runtimeDependencies = [
		libXrender  libXrandr  libXcursor  libX11  libXext  libXi  libxcb 
		cups
		systemd.lib
		libuuid
		libatomic_ops
		libgcc
		gcc
		libnsl 
		gcc-unwrapped.lib
		pulseaudio
		glibc
		libstdcxx5
		mesa
		libGL
		nss
		libdrm
	];


	installPhase = ''
		cp -r . $out
	'';


	meta = with stdenv.lib; {
		description = "Microsoft Edge";
		license = licenses.unfree;
		maintainers = [];
		platforms = [ "x86_64-linux" ];
	};
}
