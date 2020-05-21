{ lib
, stdenv
, fetchFromGitHub
, qttools
, coreutils
}:
stdenv.mkDerivation rec {

  pname = "day-night-plasma-wallpapers";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "SCOTT-HAMILTON";
    repo = "Day-night-plasma-wallpapers";
    rev = "59311ffd7f5861a447cec53d17873150628a8815";
    sha256 = "1km2qp6bx76vfwg3s1wk8phmrrx7cdzqp8h2i99rmw805ky32ch5";
  };

  buildInputs = [ qttools ];

  installPhase = ''
    install -Dm 555 update-day-night-plasma-wallpapers.sh $out/bin/update-day-night-plasma-wallpapers.sh
    install -D macOS-Mojave-Light/macOS-Mojave-Day-wallpaper.jpg $out/usr/share/wallpapers/macOS-Mojave-Light/macOS-Mojave-Day-wallpaper.jpg
    install -D macOS-Mojave-Night/macOS-Mojave-Night-wallpaper.jpg $out/usr/share/wallpapers/macOS-Mojave-Night/macOS-Mojave-Night-wallpaper.jpg
  '';

  meta = {
    description = "KDE Plasma utility to automatically change to a night wallpaper when the sun is reaching sunset.";
    license = lib.licenses.mit;
    homepage = "https://github.com/SCOTT-HAMILTON/Day-night-plasma-wallpapers";
    maintainers = with lib.maintainers; [ shamilton ];
    platforms = stdenv.lib.platforms.linux;
  };
}
