{ stdenv, lib, fetchFromGitHub, autoreconfHook, ldc, installShellFiles, pkgconfig
, curl, sqlite, libnotify
, withSystemd ? stdenv.isLinux, systemd ? null }:

stdenv.mkDerivation rec {
  pname = "onedrive";
  version = "2.4.7";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = pname;
    rev = "v${version}";
    sha256 = "12g2z6c4f65y8cc7vyhk9nlg1mpbsmlsj7ghlny452qhr13m7qpn";
  };

  nativeBuildInputs = [ autoreconfHook ldc installShellFiles pkgconfig ];

  buildInputs = [
    curl sqlite libnotify
  ] ++ lib.optional withSystemd systemd;

  configureFlags = [
    "--enable-notifications"
  ] ++ lib.optionals withSystemd [
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  # we could also pass --enable-completions to configure but we would then have to
  # figure out the paths manually and pass those along.
  postInstall = ''
    installShellCompletion --bash --name ${pname}  contrib/completions/complete.bash
    installShellCompletion --zsh  --name _${pname} contrib/completions/complete.zsh
  '';

  meta = with stdenv.lib; {
    description = "A complete tool to interact with OneDrive on Linux";
    homepage = "https://github.com/abraunegg/onedrive";
    license = licenses.gpl3;
    maintainers = with maintainers; [ srgom ianmjones ];
    platforms = platforms.linux;
  };
}
