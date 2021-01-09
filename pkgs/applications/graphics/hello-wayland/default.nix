{ stdenv, lib, fetchFromGitHub
, imagemagick, pkg-config, wayland, wayland-protocols
}:

stdenv.mkDerivation {
  pname = "hello-wayland-unstable";
  version = "2020-07-27";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "hello-wayland";
    rev = "501d0851cfa7f21c780c0eb52f0a6b23f02918c5";
    sha256 = "0dz6przqp57kw8ycja3gw6jp9x12217nwbwdpgmvw7jf0lzhk4xr";
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
