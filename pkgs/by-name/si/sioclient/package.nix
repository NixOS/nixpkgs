{ lib
, stdenv
, fetchFromGitHub
, cmake
, asio
, rapidjson
, websocketpp
}:

stdenv.mkDerivation {
  pname = "sioclient";
  version = "3.1.0-unstable-2023-11-10";

  src = fetchFromGitHub {
    owner = "socketio";
    repo = "socket.io-client-cpp";
    rev = "0dc2f7afea17a0e5bfb5e9b1e6d6f26ab1455cef";
    hash = "sha256-iUKWDv/CS2e68cCSM0QUobkfz2A8ZjJ7S0zw7rowQJ0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    asio
    rapidjson
    websocketpp
  ];

  meta = with lib; {
    description = "C++11 implementation of Socket.IO client";
    homepage = "https://github.com/socketio/socket.io-client-cpp";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
