{ stdenv, fetchurl, git, bash }:

let version = "1.04"; in
let link = "https://raw.githubusercontent.com/TheLocehiliosan/yadm/${version}"; in
stdenv.mkDerivation {
  name = "yadm-${version}";
  isLibrary = false;
  isExecutable = true;

  exe = fetchurl {
    url = "${link}/yadm";
    sha256 = "c2a7802e45570d5123f9e5760f6f92f1205f340ce155b47b065e1a1844145067";
  };

  man = fetchurl {
    url = "${link}/yadm.1";
    sha256 = "868755b19b9115cceb78202704a83ee204c2921646dd7814f8c25dd237ce09b2";
  };

  buildCommand = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    sed -e 's:/bin/bash:/usr/bin/env bash:' $exe > $out/bin/yadm
    chmod 755 $out/bin/yadm
    install -m 644 $man $out/share/man/man1/yadm.1
  '';

  meta = {
    homepage = "https://github.com/TheLocehiliosan/yadm";
    description = "Yet Another Dotfiles Manager";
    longDescription = ''
    yadm is a dotfile management tool with 3 main features: Manages files across
    systems using a single Git repository. Provides a way to use alternate files on
    a specific OS or host. Supplies a method of encrypting confidential data so it
    can safely be stored in your repository.
    '';
    licence = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}


