{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "syncthing-inotify-${version}";
  version = "0.8.4";

  goPackagePath = "github.com/syncthing/syncthing-inotify";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing-inotify";
    rev = "v${version}";
    sha256 = "0iix4gd5zh2ydn429jmcf0pr1pxxd1wq1vp5ciq9bavhvnim9clw";
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
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -delete_rpath $out/lib -add_rpath $bin $bin/bin/syncthing-inotify
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/syncthing/syncthing-inotify;
    description = "File watcher intended for use with Syncthing";
    license = licenses.mpl20;
    maintainers = with maintainers; [ joko peterhoeg ];
    platforms = platforms.unix;
  };
}
