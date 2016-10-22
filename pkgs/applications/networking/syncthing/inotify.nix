{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "syncthing-inotify-${version}";
  version = "0.8.3";

  goPackagePath = "github.com/syncthing/syncthing-inotify";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing-inotify";
    rev = "v${version}";
    sha256 = "194pbz9zzxaz0vri93czpbsxl85znlba2gy61mjgyr0dm2h4s6yw";
  };

  goDeps = ./inotify-deps.nix;

  postInstall = ''
    mkdir -p $bin/etc/systemd/{system,user}

    substitute $src/etc/linux-systemd/system/syncthing-inotify@.service \
               $bin/etc/systemd/system/syncthing-inotify@.service \
               --replace /usr/bin/syncthing-inotify $bin/bin/syncthing-inotify

    substitute $src/etc/linux-systemd/user/syncthing-inotify.service \
               $bin/etc/systemd/user/syncthing-inotify.service \
               --replace /usr/bin/syncthing-inotify $bin/bin/syncthing-inotify
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/syncthing/syncthing-inotify;
    description = "File watcher intended for use with Syncthing";
    license = licenses.mpl20;
    maintainers = with maintainers; [ joko peterhoeg ];
    platforms = platforms.unix;
  };
}
