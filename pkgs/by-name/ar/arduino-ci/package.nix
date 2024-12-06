{ lib, stdenv, fetchFromGitHub,  makeWrapper, arduino-cli, ruby, python3 }:

let

  runtimePath = lib.makeBinPath [
    arduino-cli
    python3 # required by the esp8266 core
  ];

in
stdenv.mkDerivation rec {
  pname = "arduino-ci";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner  = "pololu";
    repo   = "arduino-ci";
    rev    = "v${version}";
    sha256 = "sha256-9RbBxgwsSQ7oGGKr1Vsn9Ug9AsacoRgvQgd9jbRQ034=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install $src/ci.rb $out/bin/arduino-ci

    runHook postInstall
  '';

  fixupPhase = ''
    substituteInPlace $out/bin/arduino-ci --replace "/usr/bin/env nix-shell" "${ruby}/bin/ruby"
    wrapProgram $out/bin/arduino-ci --prefix PATH ":" "${runtimePath}"
  '';

  meta = with lib; {
    description = "CI for Arduino Libraries";
    mainProgram = "arduino-ci";
    homepage = src.meta.homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
