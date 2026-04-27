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
  gocryptfs,
  which,
  ps,
  gnugrep,
  man,
  asciidoctor,
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
    gocryptfs
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "backintime-common";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "bit-team";
    repo = "backintime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/33Lx62S/9RcqrfJumE6/o3KnAObBa3DcmuGkcOXIQE=";
  };

  nativeBuildInputs = [
    makeWrapper
    gettext
  ];

  buildInputs = [
    python'
    man
    asciidoctor
  ];

  installFlags = [ "DEST=$(out)" ];

  configureFlags = [ "--python=${lib.getExe python'}" ];

  preConfigure = ''
    patchShebangs --build updateversion.sh
    patchShebangs --build doc/manpages/build_manpages.sh
    cd common
    substituteInPlace configure \
      --replace-fail "/../etc" "/etc" \
      --replace-fail "share/backintime" "${python'.sitePackages}/backintime"

    substituteInPlace "backintime" "backintime-askpass" \
      --replace-fail "share" "${python'.sitePackages}"

    substituteInPlace "schedule.py" \
      --replace-fail "'crontab'" "'${cron}/bin/crontab'" \
      --replace-fail "'which'" "'${lib.getExe which}'" \
      --replace-fail "'ps'" "'${lib.getExe ps}'" \
      --replace-fail "'grep'" "'${lib.getExe gnugrep}'" \

    substituteInPlace "bitlicense.py" \
      --replace-fail "/usr/share/doc" "$out/share/doc" \
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
})
