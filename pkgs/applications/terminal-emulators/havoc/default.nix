{ lib
, stdenv
, fetchFromGitHub
, libxkbcommon
, pkg-config
, wayland
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "havoc";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ii8";
    repo = pname;
    rev = version;
    hash = "sha256-zNKDQqkDeNj5fB5EdMVfAs2H4uBgLh6Fp3uSjiJ1VhQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    wayland
    wayland-protocols
  ];

  dontConfigure = true;

  installFlags = [ "PREFIX=$$out" ];

  postInstall = ''
    install -D -m 644 havoc.cfg -t $out/etc/${pname}/
    install -D -m 644 README.md -t $out/share/doc/${pname}-${version}/
  '';

  meta = with lib; {
    homepage = "https://github.com/ii8/havoc";
    description = "A minimal terminal emulator for Wayland";
    license = with licenses; [ mit publicDomain ];
    platforms = with platforms; unix;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
