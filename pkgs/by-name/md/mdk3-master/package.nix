{ lib
, stdenv
, fetchFromGitHub
, wirelesstools
}:

stdenv.mkDerivation rec {
  pname = "mdk3-master";
  version = "unstable-2015-05-24";

  src = fetchFromGitHub {
    owner = "charlesxsh";
    repo = "mdk3-master";
    rev = "1bf2bd31b79560aa99fc42123f70f36a03154b9e";
    hash = "sha256-Jxyv7aoL8l9M7JheazJ+/YqfkDcSNx3ARNhx3G5Y+cM=";
  };

  runtimeDependencies = [ wirelesstools ];

  installPhase = ''
    make -C osdep install
    mkdir -p $out/bin
    install -D -m 0755 mdk3 $out/bin/
  '';

  meta = with lib; {
    description = "Modifications to MDK3 to reboot Access Points";
    homepage = "https://github.com/charlesxsh/mdk3-master";
    changelog = "https://github.com/charlesxsh/mdk3-master/blob/${src.rev}/CHANGELOG";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pinpox ];
    mainProgram = "mdk3-master";
    platforms = platforms.all;
  };
}
