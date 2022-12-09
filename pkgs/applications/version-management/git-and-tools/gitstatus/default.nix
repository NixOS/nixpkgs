{ callPackage, lib, stdenv, fetchFromGitHub, git, zsh }:

stdenv.mkDerivation rec {
  pname = "gitstatus";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "v${version}";
    sha256 = "sha256-mVfB3HWjvk4X8bmLEC/U8SKBRytTh/gjjuReqzN5qTk=";
  };

  buildInputs = [ (callPackage ./romkatv_libgit2.nix { }) ];

  postPatch = ''
    sed -i '1i GITSTATUS_AUTO_INSTALL=''${GITSTATUS_AUTO_INSTALL-0}' gitstatus.plugin.sh
    sed -i '1i GITSTATUS_AUTO_INSTALL=''${GITSTATUS_AUTO_INSTALL-0}' gitstatus.plugin.zsh
    sed -i "1a GITSTATUS_DAEMON=$out/bin/gitstatusd" install
  '';

  installPhase = ''
    install -Dm755 usrbin/gitstatusd $out/bin/gitstatusd
    install -Dm444 gitstatus.plugin.sh -t $out/share/gitstatus/
    install -Dm444 gitstatus.plugin.zsh -t $out/share/gitstatus/
    install -Dm555 install -t $out/share/gitstatus/
    install -Dm444 build.info -t $out/share/gitstatus/

    # the fallback path is wrong in the case of home-manager
    # because the FHS directories don't start at /
    substituteInPlace install \
      --replace "_gitstatus_install_main ." "_gitstatus_install_main $out"
  '';

  # Don't install the "install" and "build.info" files, which the end user
  # should not need to worry about.
  pathsToLink = [
    "/bin/gitstatusd"
    "/share/gitstatus/gitstatus.plugin.sh"
    "/share/gitstatus/gitstatus.plugin.zsh"
  ];

  # The install check sets up an empty Git repository and a minimal zshrc that
  # invokes gitstatus.plugin.zsh. It runs zsh against this zshrc and verifies
  # that the script was sourced successfully and that the "gitstatus_query"
  # command ran successfully. This tests the binary itself and the zsh
  # integration.
  installCheckInputs = [ git zsh ];
  doInstallCheck = true;
  installCheckPhase = ''
    TEMP=$(mktemp -d)
    cd "$TEMP"

    git init

    echo '
      GITSTATUS_LOG_LEVEL=DEBUG
      . $out/share/gitstatus/gitstatus.plugin.zsh || exit 1

      gitstatus_stop NIX_TEST && gitstatus_start NIX_TEST
      gitstatus_query NIX_TEST
      if [[ $? -ne 0 ]]; then
          print -- "Something went wrong with gitstatus"
          exit 1
      elif [[ $VCS_STATUS_RESULT != "ok-sync" ]]; then
          print -- "Not in a Git repo"
          exit 1
      else
          print -- "OK"
          exit 0
      fi
    ' > .zshrc

    # If we try to run zsh like "zsh -i -c true" or "zsh -i > output" then job
    # control will be disabled in the shell and the gitstatus plugin script
    # will fail when it tries to set the MONITOR option. As a workaround, we
    # run zsh as a full-fledged independent process and then wait for it to
    # exit. (The "exit" statements in the zshrc ensure that zsh will exit
    # almost immediately after starting.)
    ZDOTDIR=. zsh -i &
    wait $!
  '';

  meta = with lib; {
    description = "10x faster implementation of `git status` command";
    homepage = "https://github.com/romkatv/gitstatus";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mmlb hexa SuperSandro2000 ];
    platforms = platforms.all;
  };
}
