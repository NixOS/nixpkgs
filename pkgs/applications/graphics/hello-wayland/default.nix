{ stdenv, lib, fetchFromGitHub
, imagemagick, pkg-config, wayland, wayland-protocols
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "hello-wayland";
  version = "unstable-2023-04-23";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "hello-wayland";
    rev = "77e270c19672f3ad863e466093f429cde8eb1f16";
    sha256 = "NMQE2zU858b6OZhdS2oZnGvLK+eb7yU0nFaMAcpNw04=";
  };

  nativeBuildInputs = [ imagemagick pkg-config ];
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
