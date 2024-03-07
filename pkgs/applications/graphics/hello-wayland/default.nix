{ stdenv, lib, fetchFromGitHub
, imagemagick, pkg-config, wayland-scanner, wayland, wayland-protocols
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "hello-wayland";
  version = "unstable-2023-10-26";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "hello-wayland";
    rev = "b631afa4f6fd86560ccbdb8c7b6fe42851c06a57";
    sha256 = "MaBzGZ05uCoeeiglFYHC40hQlPvtDw5sQhqXgtVDySc=";
  };

  separateDebugInfo = true;

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ imagemagick pkg-config wayland-scanner ];
  buildInputs = [ wayland wayland-protocols ];

  installPhase = ''
    runHook preBuild
    mkdir -p $out/bin
    install hello-wayland $out/bin
    runHook postBuild
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Hello world Wayland client";
    homepage = "https://github.com/emersion/hello-wayland";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
