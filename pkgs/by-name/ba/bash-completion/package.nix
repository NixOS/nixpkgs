{ lib, stdenv, fetchurl
, autoreconfHook
, perl
, ps
, python3Packages
, bashInteractive
}:

stdenv.mkDerivation rec {
  pname = "bash-completion";
  version = "2.14.0";

  # Using fetchurl because fetchGithub or fetchzip will have trouble on
  # e.g. APFS filesystems (macOS) because of non UTF-8 characters in some of the
  # test fixtures that are part of the repository.
  # See discussion in https://github.com/NixOS/nixpkgs/issues/107768
  src = fetchurl {
    url = "https://github.com/scop/bash-completion/releases/download/${version}/bash-completion-${version}.tar.xz";
    sha256 = "sha256-XHSU+WgoCDLWrbWqGfdFpW8aed8xHlkzjF76b3KF4Wg=";
  };

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook ];

  # tests are super flaky unfortunately, and regularly break.
  # let's disable them for now.
  doCheck = false;
  nativeCheckInputs = [
    # perl is assumed by perldoc completion
    perl
    # ps assumed to exist by gdb, killall, pgrep, pidof,
    # pkill, pwdx, renice, and reptyr completions
    ps
    python3Packages.pexpect
    python3Packages.pytest
    bashInteractive
  ];

  # - ignore test_gcc on ARM because it assumes -march=native
  # - ignore test_chsh because it assumes /etc/shells exists
  # - ignore test_ether_wake, test_ifdown, test_ifstat, test_ifup,
  #   test_iperf, test_iperf3, test_nethogs and ip_addresses
  #   because they try to touch network
  # - ignore test_ls because impure logic
  # - ignore test_screen because it assumes vt terminals exist
  checkPhase = ''
    pytest . \
      ${lib.optionalString stdenv.hostPlatform.isAarch "--ignore=test/t/test_gcc.py"} \
      --ignore=test/t/test_chsh.py \
      --ignore=test/t/test_ether_wake.py \
      --ignore=test/t/test_ifdown.py \
      --ignore=test/t/test_ifstat.py \
      --ignore=test/t/test_ifup.py \
      --ignore=test/t/test_iperf.py \
      --ignore=test/t/test_iperf3.py \
      --ignore=test/t/test_nethogs.py \
      --ignore=test/t/unit/test_unit_ip_addresses.py \
      --ignore=test/t/test_ls.py \
      --ignore=test/t/test_screen.py
  '';

  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i -e 's/readlink -f/readlink/g' bash_completion completions/*
  '' + lib.optionalString stdenv.hostPlatform.isFreeBSD ''
    # please remove this next release!
    touch completions/{pkg_delete,freebsd-update,kldload,kldunload,portinstall,portsnap,portupgrade}
  '';

  meta = with lib; {
    homepage = "https://github.com/scop/bash-completion";
    description = "Programmable completion for the bash shell";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philiptaron ];
  };
}
