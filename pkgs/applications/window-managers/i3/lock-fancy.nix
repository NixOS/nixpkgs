{ stdenv, fetchFromGitHub, coreutils, scrot, imagemagick, gawk
, i3lock-color, getopt, fontconfig
}:

stdenv.mkDerivation rec {
  rev = "3734fba160166006521e513f5734eb76ac6aa48f";
  name = "i3lock-fancy-unstable-2017-12-14_rev${builtins.substring 0 7 rev}";
  src = fetchFromGitHub {
    owner = "meskarune";
    repo = "i3lock-fancy";
    inherit rev;
    sha256 = "1bg4xds2hmbq8rp6azbdqvgp1aaq5y1bp05cfwqqm6y3sjw7ywzl";
  };
  patchPhase = ''
    sed -i -e "s|(mktemp)|(${coreutils}/bin/mktemp)|" lock
    sed -i -e "s|'rm -f |'${coreutils}/bin/rm -f |" lock
    sed -i -e "s|scrot -z |${scrot}/bin/scrot -z |" lock
    sed -i -e "s|convert |${imagemagick.out}/bin/convert |" lock
    sed -i -e "s|awk -F|${gawk}/bin/awk -F|" lock
    sed -i -e "s| awk | ${gawk}/bin/awk |" lock
    sed -i -e "s|i3lock -i |${i3lock-color}/bin/i3lock-color -i |" lock
    sed -i -e 's|icon="$scriptpath/icons/lockdark.png"|icon="'$out'/share/i3lock-fancy/icons/lockdark.png"|' lock
    sed -i -e 's|icon="$scriptpath/icons/lock.png"|icon="'$out'/share/i3lock-fancy/icons/lock.png"|' lock
    sed -i -e "s|getopt |${getopt}/bin/getopt |" lock
    sed -i -e "s|fc-match |${fontconfig.bin}/bin/fc-match |" lock
    sed -i -e "s|shot=(import -window root)|shot=(${scrot}/bin/scrot -z)|" lock
  '';
  installPhase = ''
    mkdir -p $out/bin $out/share/i3lock-fancy/icons
    cp lock $out/bin/i3lock-fancy
    cp icons/lock*.png $out/share/i3lock-fancy/icons
  '';
  meta = with stdenv.lib; {
    description = "i3lock is a bash script that takes a screenshot of the desktop, blurs the background and adds a lock icon and text.";
    homepage = https://github.com/meskarune/i3lock-fancy;
    maintainers = with maintainers; [ garbas ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
