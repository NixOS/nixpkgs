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
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
}:

stdenv.mkDerivation rec {
  pname = "onedrive";
<<<<<<< HEAD
  version = "2.4.25";
=======
  version = "2.4.23";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-M6EOJiykmAKWIuAXdm9ebTSX1eVoO+1axgzxlAmuI8U=";
=======
    hash = "sha256-yHpjutZV2u1VhnLxsQIu0NtKnqwtoRn4TM+8tXJ4RNo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    installShellCompletion --fish --name ${pname}  contrib/completions/complete.fish
  '';

  meta = with lib; {
    description = "A complete tool to interact with OneDrive on Linux";
    homepage = "https://github.com/abraunegg/onedrive";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ srgom peterhoeg bertof ];
    platforms = platforms.linux;
  };
}
