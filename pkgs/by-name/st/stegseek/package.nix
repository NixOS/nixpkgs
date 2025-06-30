{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  libjpeg,
  libmcrypt,
  libmhash,
  libtool,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "stegseek";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "RickdeJager";
    repo = "stegseek";
    rev = "v${version}";
    sha256 = "sha256-B5oJffYOYfsH0YRq/Bq0ciIlCsCONyScFBjP7a1lIzo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libjpeg
    libmcrypt
    libmhash
    libtool
    zlib
  ];

  # tests get stuck on aarch64-linux
  doCheck = stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Tool to crack steganography";
    longDescription = ''
      Stegseek is a lightning fast steghide cracker that can be
      used to extract hidden data from files.
    '';
    homepage = "https://github.com/RickdeJager/stegseek";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "stegseek";
  };
}
