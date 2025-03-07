{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "clematis";
  version = "2022-04-16";

  src = fetchFromGitHub {
    owner = "TorchedSammy";
    repo = "clematis";
    rev = "cbe74da084b9d3f6893f53721c27cd0f3a45fe93";
    sha256 = "sha256-TjoXHbY0vUQ2rhwdCJ/s/taRd9/MG0P9HaEw2BOIy/s=";
  };

  vendorHash = "sha256-YKu+7LFUoQwCH//URIswiaqa0rmnWZJvuSn/68G3TUA=";

  meta = with lib; {
    description = "Discord rich presence for MPRIS music players";
    homepage = "https://github.com/TorchedSammy/Clematis";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ misterio77 ];
    mainProgram = "clematis";
  };
}
