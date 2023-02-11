{ lib
, stdenv
, fetchFromGitHub
, coreutils
, scrot
, imagemagick
, gawk
, i3lock-color
, getopt
, fontconfig
}:

stdenv.mkDerivation rec {
  pname = "i3lock-fancy";
  version = "unstable-2018-11-25";

  src = fetchFromGitHub {
    owner = "meskarune";
    repo = "i3lock-fancy";
    rev = "7accfb2aa2f918d1a3ab975b860df1693d20a81a";
    sha256 = "00lqsvz1knb8iqy8lnkn3sf4c2c4nzb0smky63qf48m8za5aw9b1";
  };

  postPatch = ''
    sed -i i3lock-fancy \
      -e "s|mktemp|${coreutils}/bin/mktemp|" \
      -e "s|'rm -f |'${coreutils}/bin/rm -f |" \
      -e "s|scrot -z |${scrot}/bin/scrot -z |" \
      -e "s|convert |${imagemagick.out}/bin/convert |" \
      -e "s|awk -F|${gawk}/bin/awk -F|" \
      -e "s| awk | ${gawk}/bin/awk |" \
      -e "s|i3lock -i |${i3lock-color}/bin/i3lock-color -i |" \
      -e 's|icon="/usr/share/i3lock-fancy/icons/lockdark.png"|icon="'$out'/share/i3lock-fancy/icons/lockdark.png"|' \
      -e 's|icon="/usr/share/i3lock-fancy/icons/lock.png"|icon="'$out'/share/i3lock-fancy/icons/lock.png"|' \
      -e "s|getopt |${getopt}/bin/getopt |" \
      -e "s|fc-match |${fontconfig.bin}/bin/fc-match |" \
      -e "s|shot=(import -window root)|shot=(${scrot}/bin/scrot -z -o)|"
    rm Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/i3lock-fancy/icons
    cp i3lock-fancy $out/bin/i3lock-fancy
    ln -s $out/bin/i3lock-fancy $out/bin/i3lock
    cp icons/lock*.png $out/share/i3lock-fancy/icons
  '';

  meta = with lib; {
    description = "i3lock is a bash script that takes a screenshot of the desktop, blurs the background and adds a lock icon and text";
    homepage = "https://github.com/meskarune/i3lock-fancy";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
