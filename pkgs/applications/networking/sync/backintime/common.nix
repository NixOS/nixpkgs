{stdenv, lib, fetchFromGitHub, makeWrapper, gettext,
python3, rsync, cron, openssh, sshfs-fuse, encfs }:

let
  python' = python3.withPackages (ps: with ps; [ dbus-python keyring ]);

  apps = lib.makeBinPath [ openssh python' cron rsync sshfs-fuse encfs ];
in stdenv.mkDerivation rec {
  pname = "backintime-common";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "bit-team";
    repo = "backintime";
    rev = "v${version}";
    sha256 = "sha256-7iTQZ7SiESsKK8F8BpLrRNkj8JhHo64kliaOvMvYGvw=";
  };

  nativeBuildInputs = [ makeWrapper gettext ];
  buildInputs = [ python' ];

  installFlags = [ "DEST=$(out)" ];

  preConfigure = ''
    cd common
    substituteInPlace configure \
      --replace "/.." "" \
      --replace "share/backintime" "${python'.sitePackages}/backintime"
    substituteInPlace "backintime" \
      --replace "share" "${python'.sitePackages}"
  '';

  dontAddPrefix = true;

  preFixup = ''
    wrapProgram "$out/bin/backintime" \
      --prefix PATH : ${apps}
    '';

  meta = {
    homepage = "https://github.com/bit-team/backintime";
    description = "Simple backup tool for Linux";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.all;
    longDescription = ''
      Back In Time is a simple backup tool (on top of rsync) for Linux
      inspired from “flyback project” and “TimeVault”. The backup is
      done by taking snapshots of a specified set of directories.
    '';
  };
}
