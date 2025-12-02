{
  lib,
  stdenv,
  fetchFromGitHub,
  gzip,
  popt,
  autoreconfHook,
  aclSupport ? stdenv.hostPlatform.isLinux,
  acl,
  coreutils,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "logrotate";
  version = "3.22.0";

  src = fetchFromGitHub {
    owner = "logrotate";
    repo = "logrotate";
    rev = version;
    sha256 = "sha256-D7E2mpC7v2kbsb1EyhR6hLvGbnIvGB2MK1n1gptYyKI=";
  };

  # Logrotate wants to access the 'mail' program; to be done.
  configureFlags = [
    "--with-compress-command=${gzip}/bin/gzip"
    "--with-uncompress-command=${gzip}/bin/gunzip"
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ popt ] ++ lib.optionals aclSupport [ acl ];

  preCheck = ''
    sed -i 's#/bin/date#${lib.getExe' coreutils "date"}#' test/*.sh
    # Exiting with 77 signals that a test is skipped, and we only place it on line 2 because the shebang is on line 1
    # Does not work on certain filesystems due to incorrect sparse file detection.
    # Upstream issue: https://github.com/logrotate/logrotate/issues/682
    sed -i '2iexit 77' test/test-0062.sh
    sed -i '2iexit 77' test/test-0063.sh
    # Depends on a working root user, which we don't have in the sandbox
    sed -i '2iexit 77' test/test-0110.sh
  '';
  doCheck = true;

  passthru.tests = {
    nixos-logrotate = nixosTests.logrotate;
  };

  meta = with lib; {
    homepage = "https://github.com/logrotate/logrotate";
    description = "Rotates and compresses system logs";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.tobim ];
    platforms = platforms.all;
    mainProgram = "logrotate";
  };
}
