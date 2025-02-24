{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  libnotify,
  slop,
  ffcast,
  ffmpeg,
  xclip,
  rofi,
  coreutils,
  gnused,
  procps,
}:

stdenv.mkDerivation rec {
  pname = "rofi-screenshot";
  version = "2024-09-27";

  src = fetchFromGitHub {
    owner = "ceuk";
    repo = pname;
    rev = "09a07d9c2ff2efbf75b1753bb412f4f8f086708f";
    hash = "sha256-3UpYdXAX3LD1ZAQ429JkzWWooiBpuf/uPf0CRh5EXd8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --set PATH ${
        lib.makeBinPath [
          libnotify
          slop
          ffcast
          ffmpeg
          xclip
          rofi
          coreutils
          gnused
          procps
        ]
      }
  '';

  installPhase = ''
    install -Dm755 ${pname} $out/bin/${pname}
  '';

  meta = {
    description = "Use rofi to perform various types of screenshots and screen captures";
    mainProgram = "rofi-screenshot";
    homepage = "https://github.com/ceuk/rofi-screenshot";
    maintainers = with lib.maintainers; [ zopieux ];
    platforms = lib.platforms.all;
    license = lib.licenses.wtfpl;
  };
}
