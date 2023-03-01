{ lib
, pkgs
, file
, openssl
, stdenv
, fetchFromGitHub
, waylandSupport ? stdenv.isLinux
, x11Support ? stdenv.isLinux
}:

stdenv.mkDerivation rec {
  pname = "ctpv";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "NikitaIvanovV";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-0OuskRCBVm8vMd2zH5u5EPABmCOlEv5N4ZZMdc7bAwM=";
  };

  nativeBuildInputs = [
    file # libmagic
    openssl
  ];

  buildInputs = with pkgs; [
    ffmpegthumbnailer ffmpeg
  ] ++ lib.optional waylandSupport [ chafa ]
    ++ lib.optional x11Support [ ueberzug ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Image previews for lf (list files) file manager";
    homepage = "https://github.com/NikitaIvanovV/ctpv";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.wesleyjrz ];
  };
}
