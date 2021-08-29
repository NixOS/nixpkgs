{ stdenv
, fetchFromGitHub
, poco
, pkg-config
, gnome2
, gtkmm2
, lib
}:

stdenv.mkDerivation rec {
  pname = "timekeeper";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "bburdette";
    repo = "TimeKeeper";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "03rvzkygnn7igcindbb5bcmfy0l83n0awkzprsnhlb6ndxax3k9w";
  };

  nativeBuildInputs = [
    poco
    pkg-config
  ];

  buildInputs = [
    gtkmm2
    gnome2.libglademm
    gnome2.libglade
  ];

  installPhase = ''
    install -Dm755 TimeKeeper/TimeKeeper $out/bin/timekeeper
    '';

  meta = with lib; {
    description = "Log hours worked and make reports";
    homepage = "https://github.com/bburdette/TimeKeeper";
    maintainers = with maintainers; [ bburdette ];
    platforms = [ "x86_64-linux" ];
    license = licenses.bsd3;
  };
}
