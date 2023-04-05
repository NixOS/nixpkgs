{ stdenv, lib, fetchFromGitHub
, imagemagick, pkg-config, wayland, wayland-protocols
}:

stdenv.mkDerivation {
  pname = "hello-wayland";
  version = "unstable-2023-03-16";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "hello-wayland";
    rev = "f6a8203309977af03cda94765dd61367c189bea6";
    sha256 = "FNtc6OApW/epAFortvujNVWJJVI44IY+Pa0qU0QdecA=";
  };

  nativeBuildInputs = [ imagemagick pkg-config ];
  buildInputs = [ wayland wayland-protocols ];

  installPhase = ''
    runHook preBuild
    mkdir -p $out/bin
    install hello-wayland $out/bin
    runHook postBuild
  '';

  meta = with lib; {
    description = "Hello world Wayland client";
    homepage = "https://github.com/emersion/hello-wayland";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
