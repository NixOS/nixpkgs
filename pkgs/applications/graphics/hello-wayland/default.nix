{ stdenv, lib, fetchFromGitHub
, imagemagick, pkg-config, wayland-scanner, wayland, wayland-protocols
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "hello-wayland";
  version = "0-unstable-2024-03-04";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "hello-wayland";
    rev = "5f3a35def81116f0a74fcaf5a421d66c6700482d";
    hash = "sha256-gcLR8gosQlPPgFrxqmRQ6/59RjAfJNX6CcsYP+L+A58=";
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
    mainProgram = "hello-wayland";
  };
}
