{ stdenv
, fetchFromGitHub
, unstableGitUpdater
, cmake
, lib
}: stdenv.mkDerivation rec {
  pname = "mdns-reflector";
  version = "unstable-2023-09-15";
  src = fetchFromGitHub {
    owner = "vfreex";
    repo = "mdns-reflector";
    rev = "4b4cd3b196f09b507d9a32c7488491bbd5071ba6";
    sha256 = "sha256-AzH1rZFqEH8sovZZfJykvsEmCedEZWigQFHWHl6/PdE=";
  };

  buildInputs = [ cmake ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/vfreex/mdns-reflector.git";
  };

  meta = with lib; {
    description = "A lightweight and performant multicast DNS (mDNS) reflector";
    homepage = "https://github.com/vfreex/mdns-reflector";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bcnelson ];
    mainProgram = "mdns-reflector";
  };
}
