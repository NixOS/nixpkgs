{ stdenv, fetchFromGitHub, coreutils, scrot, imagemagick, gawk
, i3lock-color
}:

stdenv.mkDerivation rec {
  rev = "b7196aaff72b90bb6ea0464a9f7b37d140db3230";
  name = "i3lock-fancy-2016-05-05_rev${builtins.substring 0 7 rev}";
  src = fetchFromGitHub {
    owner = "meskarune";
    repo = "i3lock-fancy";
    inherit rev;
    sha256 = "0az43nqhmbniih3yw9kz5lnky0n7mxylvklsib76s4l2alf6i3ps";
  };
  patchPhase = ''
    sed -i -e "s|mktemp|${coreutils}/bin/mktemp|" lock
    sed -i -e "s|\`pwd\`|$out/share/i3lock-fancy|" lock
    sed -i -e "s|dirname|${coreutils}/bin/dirname|" lock
    sed -i -e "s|rm |${coreutils}/bin/rm |" lock
    sed -i -e "s|scrot |${scrot}/bin/scrot |" lock
    sed -i -e "s|convert |${imagemagick.out}/bin/convert |" lock
    sed -i -e "s|awk |${gawk}/bin/awk|" lock
    sed -i -e "s|i3lock |${i3lock-color}/bin/i3lock-color |" lock
  '';
  installPhase = ''
    mkdir -p $out/bin $out/share/i3lock-fancy
    cp lock $out/bin/i3lock-fancy
    cp lock*.png $out/share/i3lock-fancy
  '';
  meta = with stdenv.lib; {
    description = "i3lock is a bash script that takes a screenshot of the desktop, blurs the background and adds a lock icon and text.";
    homepage = https://github.com/meskarune/i3lock-fancy;
    maintainers = with maintainers; [ garbas ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
