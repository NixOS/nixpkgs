{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libgpiod
, cmake
}:

stdenv.mkDerivation rec {
  pname = "gcfflasher";
  version = "4.0.3-beta";

  src = fetchFromGitHub {
    owner = "dresden-elektronik";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-m+iDBfsHo+PLYd3K8JaKwhIXcnj+Q8w7gIgmHp+0plk=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'main_windows.c' 'main_posix.c'
    '';

  buildInputs = lib.optionals stdenv.isLinux [
    libgpiod
  ];

  installPhase = ''
    runHook preInstall
    install -Dm0755 GCFFlasher $out/bin/GCFFlasher
    runHook postInstall
  '';

  meta = with lib; {
    description = "CFFlasher is the tool to program the firmware of dresden elektronik's Zigbee products";
    license = licenses.bsd3;
    homepage = "https://github.com/dresden-elektronik/gcfflasher";
    maintainers = with maintainers; [ fleaz ];
  };
}
