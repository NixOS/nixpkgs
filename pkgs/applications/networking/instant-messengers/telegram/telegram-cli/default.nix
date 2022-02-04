{ stdenv, fetchFromGitHub, jansson, lib, libconfig, libevent, libgcrypt, lua, lua53Packages
, makeWrapper, openssl, pkg-config, python3, readline, zlib
}:

stdenv.mkDerivation rec {
  pname = "telegram-cli";
  version = "20200106";

  src = fetchFromGitHub {
    owner = "kenorb-contrib";
    repo = "tg";
    rev = "refs/tags/${version}";
    sha256 = "sha256-wYBPr2b8IOycO9y/CNyGjnRsyGyYl3oiXYtTzwTurVA=";
    fetchSubmodules = true;
  };

  buildInputs = [
    jansson
    libconfig
    libevent
    libgcrypt
    lua
    lua53Packages.lgi
    openssl
    python3
    readline
    zlib
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 ./bin/telegram-cli $out/bin/telegram-cli-keyless
    install -Dm644 ./tg-server.pub -t $out/share/telegram-cli
    makeWrapper $out/bin/telegram-cli-keyless $out/bin/telegram-cli \
      --add-flags "-k $out/share/telegram-cli/tg-server.pub"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Command-line interface for Telegram, that uses readline interface, it's a client implementation of TGL library";
    downloadPage = "https://github.com/kenorb-contrib/tg";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
  };
}
