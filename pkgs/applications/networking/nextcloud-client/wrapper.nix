{ lib, nextcloud-client, makeWrapper, symlinkJoin, withGnomeKeyring ? false, libgnome-keyring }:

if (!withGnomeKeyring) then nextcloud-client else symlinkJoin {
  name = "${nextcloud-client.name}-with-gnome-keyring";
  paths = [ nextcloud-client ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/nextcloud" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libgnome-keyring ]}
  '';

  inherit (nextcloud-client) meta;
}
