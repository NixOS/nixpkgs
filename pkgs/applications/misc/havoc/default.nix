{ stdenv, fetchFromGitHub
, pkgconfig, libxkbcommon, wayland, wayland-protocols }:

stdenv.mkDerivation rec {

  pname = "havoc";
  version = "2019-12-08";

  src = fetchFromGitHub {
    owner = "ii8";
    repo = pname;
    rev = "507446c92ed7bf8380a58c5ba2b14aba5cdf412c";
    sha256 = "13nfnan1gmy4cqxmqv0rc8a4mcb1g62v73d56hy7z2psv4am7a09";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxkbcommon wayland wayland-protocols ];

  dontConfigure = true;

  installFlags = [ "PREFIX=$$out" ];

  postInstall = ''
    install -D -m 644 havoc.cfg -t $out/etc/${pname}/
    install -D -m 644 README.md -t $out/share/doc/${pname}-${version}/
  '';

  meta = with stdenv.lib; {
    description = "A minimal terminal emulator for Wayland";
    homepage = "https://github.com/ii8/havoc";
    license = with licenses; [ mit publicDomain ];
    platforms = with platforms; unix;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
