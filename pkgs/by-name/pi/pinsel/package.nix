{ lib, stdenv, fetchFromGitHub, pkg-config, gtk3, lua, glib }:

stdenv.mkDerivation rec {
  pname = "pinsel";
  version = "unstable-2021-09-13";

  src = fetchFromGitHub {
    owner = "Nooo37";
    repo = pname;
    rev = "24b0205ca041511b3efb2a75ef296539442f9f54";
    sha256 = "sha256-w+jiKypZODsmZq3uWGNd8PZhe1SowHj0thcQTX8WHfQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config glib ];

  buildInputs = [ lua gtk3 ];

  makeFlags = [ "INSTALLDIR=${placeholder "out"}/bin" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Minimal screenshot annotation tool with lua config";
    homepage = "https://github.com/Nooo37/pinsel";
    # no license
    license = licenses.unfree;
    maintainers = with maintainers; [ lom ];
    mainProgram = "pinsel";
  };
}
