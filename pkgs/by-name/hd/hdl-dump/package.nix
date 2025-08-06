{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "hdl-dump";
  version = "unstable-2022-09-19";

  src = fetchFromGitHub {
    owner = "ps2homebrew";
    repo = "hdl-dump";
    rev = "87d3099d2ba39a15e86ebc7dc725e8eaa49f2d5f";
    hash = "sha256-eBqF4OGEaLQXQ4JMtD/Yn+f97RzKVsnC+4oyiEhLTUM=";
  };

  makeFlags = [ "RELEASE=yes" ];

  installPhase = ''
    install -Dm755 hdl_dump -t $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/ps2homebrew/hdl-dump";
    description = "PlayStation 2 HDLoader image dump/install utility";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ makefu ];
    mainProgram = "hdl_dump";
  };
}
