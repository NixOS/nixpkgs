{
  fetchFromGitHub,
  gcc,
  gnumake,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "up-core";
  name = "up";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "up";
    rev = "1be487a84782bc62593326c35160fa782e2e7d7a";
    hash = "sha256-Ll6gHuWh2s7ke9Vqlw0H3tdKHIuvIC13TGHHKllEQ54=";
  };
  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp up-core $out/bin
    echo "#!/usr/bin/env bash" > $out/lib/SOURCE_ME.sh
    $out/bin/up-core --init >> $out/lib/SOURCE_ME.sh
    chmod +x $out/lib/SOURCE_ME.sh
  '';
  shellHook = ''
    source $out/lib/SOURCE_ME.sh
  '';
  buildInputs = [
    gcc
    gnumake
  ];
  buildPhase = "make build";
  meta = with lib; {
    description = "A fast way to go up relative directories";
    homepage = "https://github.com/NewDawn0/up";
    maintainers = with maintainers; [ NewDawn0 ];
    license = licenses.mit;
  };
}
