{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  gettext,
  python3,
  rsync,
  cron,
  openssh,
  sshfs-fuse,
  encfs,
}:

let
  python' = python3.withPackages (
    ps: with ps; [
      dbus-python
      keyring
      packaging
    ]
  );

  apps = lib.makeBinPath [
    openssh
    python'
    cron
    rsync
    sshfs-fuse
    encfs
  ];
in
stdenv.mkDerivation rec {
  pname = "backintime-common";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "bit-team";
    repo = "backintime";
    rev = "v${version}";
    sha256 = "sha256-2q2Q4rnxXwVnfH1YEBwY35B2ctG9+qpOIAHqPOjjArg=";
  };

  nativeBuildInputs = [
    makeWrapper
    gettext
  ];
  buildInputs = [ python' ];

  installFlags = [ "DEST=$(out)" ];

  configureFlags = [ "--python=${lib.getExe python'}" ];

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
    maintainers = with lib.maintainers; [ stephen-huan ];
    platforms = lib.platforms.all;
    longDescription = ''
      Back In Time is a simple backup tool (on top of rsync) for Linux
      inspired from “flyback project” and “TimeVault”. The backup is
      done by taking snapshots of a specified set of directories.
    '';
  };
}
