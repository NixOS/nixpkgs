{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "yas";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "niXman";
    repo = "yas";
    rev = version;
    hash = "sha256-2+CpftWOEnntYBCc1IoR5eySbmhrMVunpUTZRdQ5I+A=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include/yas
    cp -r include/yas/* $out/include/yas
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/niXman/yas";
    description = "Yet Another Serialization";
    license = licenses.boost;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
