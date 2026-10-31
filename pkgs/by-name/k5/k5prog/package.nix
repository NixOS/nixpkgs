{ lib
, stdenv
, fetchFromGitHub
, gsettings-desktop-schemas
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "k5prog";
  version = "unstable-2023-12-29";

  src = fetchFromGitHub {
    owner = "sq5bpf";
    repo = "k5prog";
    rev = "241ab18b61f6d8933fecf60643fe94322fbf4198";
    hash = "sha256-uzhTYCpNjm/I+qlHUF6t9+hGjAvXFlzUM34SAxX5OjE=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp k5prog $out/bin/
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/sq5bpf/k5prog.git";
  };

  meta = with lib; {
    description = "Quansheng UV-K5 EEPROM and flash programmer";
    homepage = "https://github.com/sq5bpf/k5prog";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dramaturg ];
  };
}
