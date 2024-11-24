{stdenv, lib, fetchFromGitHub, makeWrapper, gettext,
python3, rsync, cron, openssh, sshfs-fuse, encfs }:

let
  python' = python3.withPackages (ps: with ps; [ dbus-python keyring packaging ]);

  apps = lib.makeBinPath [ openssh python' cron rsync sshfs-fuse encfs ];
in stdenv.mkDerivation rec {
  pname = "backintime-common";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "bit-team";
    repo = "backintime";
    rev = "v${version}";
    sha256 = "sha256-byJyRsjZND0CQAfx45jQa3PNHhqzF2O0cFGSfN4o/QA=";
  };

  nativeBuildInputs = [ makeWrapper gettext ];
  buildInputs = [ python' ];

  installFlags = [ "DEST=$(out)" ];

  configureFlags = [ "--python=${lib.getExe python'}" ];

  preConfigure = ''
    patchShebangs --build updateversion.sh
    cd common
    substituteInPlace configure \
      --replace-fail "/.." "" \
      --replace-fail "share/backintime" "${python'.sitePackages}/backintime"
    substituteInPlace "backintime" "backintime-askpass" \
      --replace-fail "share" "${python'.sitePackages}"
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
    platforms = lib.platforms.linux;
    mainProgram = "backintime";
    longDescription = ''
      Back In Time is a simple backup tool (on top of rsync) for Linux
      inspired from "flyback project" and "TimeVault". The backup is
      done by taking snapshots of a specified set of directories.
    '';
  };
}
