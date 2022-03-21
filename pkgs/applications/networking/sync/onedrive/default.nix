{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, ldc
, installShellFiles
, pkg-config
, curl
, sqlite
, libnotify
, withSystemd ? stdenv.isLinux
, systemd
}:

stdenv.mkDerivation rec {
  pname = "onedrive";
  version = "2.4.16";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GoufEcCu/Cg2Fu0RcjTi4te/7+gZfQRTj+AtK0YnF5I=";
  };

  nativeBuildInputs = [ autoreconfHook ldc installShellFiles pkg-config ];

  buildInputs = [
    curl
    sqlite
    libnotify
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

  meta = with lib; {
    description = "A complete tool to interact with OneDrive on Linux";
    homepage = "https://github.com/abraunegg/onedrive";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ srgom peterhoeg ];
    platforms = platforms.linux;
  };
}
