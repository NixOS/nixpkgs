{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  coreutils,
  openssh,
  gnupg,
  perl,
  procps,
  gnugrep,
  gawk,
  findutils,
  gnused,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keychain";
  version = "2.9.8";

  src = fetchFromGitHub {
    owner = "funtoo";
    repo = "keychain";
    rev = finalAttrs.version;
    sha256 = "sha256-xk3ooFhBkgv93Po5oC4TZRmMhJJXDv7yekoE102FQd8=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];
  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp keychain $out/bin/keychain
    installManPage keychain.1
    wrapProgram $out/bin/keychain \
      --prefix PATH ":" "${
        lib.makeBinPath [
          coreutils
          findutils
          gawk
          gnupg
          gnugrep
          gnused
          openssh
          procps
        ]
      }" \
  '';

  meta = {
    description = "Manage SSH and GPG keys in a convenient and secure manner";
    longDescription = ''
      Keychain helps you to manage SSH and GPG keys in a convenient and secure
      manner. It acts as a frontend to ssh-agent and ssh-add, but allows you
      to easily have one long running ssh-agent process per system, rather
      than the norm of one ssh-agent per login session.

      This dramatically reduces the number of times you need to enter your
      passphrase. With keychain, you only need to enter a passphrase once
      every time your local machine is rebooted. Keychain also makes it easy
      for remote cron jobs to securely "hook in" to a long-running ssh-agent
      process, allowing your scripts to take advantage of key-based logins.
    '';
    homepage = "https://www.funtoo.org/Keychain";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sigma ];
    mainProgram = "keychain";
  };
})
