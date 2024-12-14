{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  makeWrapper,
  testers,
  runCommand,

  # dependencies
  binutils,
  coreutils,
  curl,
  elfutils,
  file,
  findutils,
  gawk,
  glibc,
  gnugrep,
  gnused,
  openssl,
  procps,
  sysctl,
  wget,
  which,

  # tests
  checksec,
}:

stdenv.mkDerivation rec {
  pname = "checksec";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "slimm609";
    repo = "checksec.sh";
    rev = version;
    hash = "sha256-BWtchWXukIDSLJkFX8M/NZBvfi7vUE2j4yFfS0KEZDo=";
  };

  patches = [
    ./0001-attempt-to-modprobe-config-before-checking-kernel.patch
    # Tool would sanitize the environment, removing the PATH set by our wrapper.
    ./0002-don-t-sanatize-the-environment.patch
    # Fix the exit code of debug_report command. Check if PR 226 was merged when upgrading version.
    (fetchpatch {
      url = "https://github.com/slimm609/checksec.sh/commit/851ebff6972f122fde5507f1883e268bbff1f23d.patch";
      hash = "sha256-DOcVF+oPGIR9VSbqE+EqWlcNANEvou1gV8qBvJLGLBE=";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase =
    let
      path = lib.makeBinPath [
        binutils
        coreutils
        curl
        elfutils
        file
        findutils
        gawk
        gnugrep
        gnused
        openssl
        procps
        sysctl
        wget
        which
      ];
    in
    ''
      mkdir -p $out/bin
      install checksec $out/bin
      substituteInPlace $out/bin/checksec \
        --replace "/bin/sed" "${gnused}/bin/sed" \
        --replace "/usr/bin/id" "${coreutils}/bin/id" \
        --replace "/lib/libc.so.6" "${glibc}/lib/libc.so.6"
      wrapProgram $out/bin/checksec \
        --prefix PATH : ${path}
    '';

  passthru.tests = {
    version = testers.testVersion {
      package = checksec;
      version = "v${version}";
    };
    debug-report = runCommand "debug-report" { buildInputs = [ checksec ]; } ''
      checksec --debug_report || exit 1
      echo "OK"
      touch $out
    '';
  };

  meta = with lib; {
    description = "Tool for checking security bits on executables";
    mainProgram = "checksec";
    homepage = "https://www.trapkit.de/tools/checksec/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      thoughtpolice
      globin
    ];
  };
}
