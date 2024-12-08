{ lib, coreutils, curl, fetchFromGitHub, unzip, p7zip, gnused, gnugrep, stdenv
, blacklist ? [ "adwords.google.com" ]
, whitelist ? [
  ".dropbox.com"
  " www.malwaredomainlists.com"
  " www.arcamax.com"
  " www.instructables.com"
  " goo.gl"
  " www.reddit.com"
  " t.co"
  " bit.ly"
  " www.viddler.com"
  " viddler.com"
  " tinyurl.com"
  " ompldr.org"
  " www.ompldr.org"
  "login.yahoo.com"
  " l.yimg.com"
  ".bp.blogspot.com"
] }:

stdenv.mkDerivation {
  pname = "hostsblock";
  version = "20161213";

  src = fetchFromGitHub {
    owner = "gaenserich";
    repo = "hostsblock";
    rev = "91cacbdfbfb5e7ae9ba3babf8de41e135270c310";
    sha256 = "1w91fbgf8v2nn0a6m8l6kd455km2j1lvpvqil4yxhrg018aigax0";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -Dm744 src/hostsblock.sh $out/bin/hostsblock
    install -Dm744 src/hostsblock-urlcheck.sh $out/bin/hostsblock-urlcheck

    mkdir -p $out/lib
    install -Dm644 src/hostsblock-common.sh $out/lib/

    mkdir -p $out/etc
    install -Dm644 conf/hostsblock.conf $out/etc/
    ${lib.concatMapStrings (d: "echo ${d} >> $out/etc/black.list\n") blacklist}
    ${lib.concatMapStrings (d: "echo ${d} >> $out/etc/white.list\n") whitelist}
    install -Dm644 conf/hosts.head $out/etc/

    for f in $out/bin/* $out/lib/* $out/etc/hostsblock.conf; do
      substituteInPlace $f --replace "/dev/shm" "/tmp"
      substituteInPlace $f --replace "/usr/lib/" "$out/lib/"
      substituteInPlace $f --replace "/etc/hostsblock/" "$out/etc/"
      sed --in-place --regexp-extended "s|([\` ])curl |\1${curl}/bin/curl |g" $f
      substituteInPlace $f --replace grep ${gnugrep}/bin/grep
      substituteInPlace $f --replace " sed " " ${gnused}/bin/sed "
      sed --in-place --regexp-extended "s|([^_])unzip |\1${unzip}/bin/unzip |" $f
      sed --in-place --regexp-extended "s|7za([^,])|${p7zip}/bin/7za\1|g" $f
    done

    echo "postprocess(){ ${coreutils}/bin/true; }" >> $out/etc/hostsblock.conf

    mkdir -p $out/share/dbus-1/system-services
    install -Dm644 systemd/hostsblock.service $out/share/dbus-1/system-services
    install -Dm644 systemd/hostsblock.timer $out/share/dbus-1/system-services
  '';

  meta = with lib; {
    description = "Ad- and malware-blocking script for Linux";
    homepage = "http://gaenserich.github.io/hostsblock/";
    license = licenses.gpl3;
    maintainers = [ maintainers.nicknovitski ];
    platforms = platforms.unix;
  };

}
