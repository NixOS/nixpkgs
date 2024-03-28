{ lib, stdenv, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  version = "unstable-2022-05-07";
  pname = "rtl-wmbus";

  src = fetchFromGitHub {
    owner = "xaelsouth";
    repo = pname;
    rev = "388e7adb8e87caba2fcd50de979a6473e66d475b";
    sha256 = "sha256-PuKoF57wUKJDZu9EwpdRP34+MBPnhEp4VKOfEE/Kog0";
  };

  makeFlags = [
    "COMMIT_HASH="
    "TAG=${src.rev}"
    "BRANCH="
    "CHANGES="
  ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace "CC=gcc" "CC?=gcc" \
      --replace "/usr" ""
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Software defined receiver for Wireless M-Bus with RTL-SDR";
    homepage = "https://github.com/xaelsouth/rtl-wmbus";
    license = licenses.bsd2;
    mainProgram = "rtl_wmbus";
    maintainers = with maintainers; [ snicket2100 ];
    platforms = platforms.unix;
  };
}
