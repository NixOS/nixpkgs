{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "libuinputplus";
  version = "2021-04-02";

  # adds missing cmake install directives
  # https://github.com/YukiWorkshop/libuInputPlus/pull/7
  patches = [ ./0001-Add-cmake-install-directives.patch ];

  src = fetchFromGitHub {
    owner = "YukiWorkshop";
    repo = "libuInputPlus";
    rev = "f7f18eb339bba61a43f2cad481a9b1a453a66957";
    sha256 = "0sind2ghhy4h9kfkr5hsmhcq0di4ifwqyv4gac96rgj5mwvs33lp";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Easy-to-use uinput library in C++";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = with platforms; linux;
  };
}
