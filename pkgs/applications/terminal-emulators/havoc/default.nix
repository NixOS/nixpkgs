{ lib, stdenv, fetchFromGitHub
, pkg-config, libxkbcommon, wayland, wayland-protocols }:

stdenv.mkDerivation rec {

  pname = "havoc";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "ii8";
    repo = pname;
    rev = version;
    sha256 = "1g05r9j6srwz1krqvzckx80jn8fm48rkb4xp68953gy9yp2skg3k";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxkbcommon wayland wayland-protocols ];

  dontConfigure = true;

  installFlags = [ "PREFIX=$$out" ];

  postInstall = ''
    install -D -m 644 havoc.cfg -t $out/etc/${pname}/
    install -D -m 644 README.md -t $out/share/doc/${pname}-${version}/
  '';

  meta = with lib; {
    description = "A minimal terminal emulator for Wayland";
    homepage = "https://github.com/ii8/havoc";
    license = with licenses; [ mit publicDomain ];
    platforms = with platforms; unix;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
