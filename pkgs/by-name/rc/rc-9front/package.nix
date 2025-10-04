{
  lib,
  stdenv,
  fetchFrom9Front,
  unstableGitUpdater,
  byacc,
  installShellFiles,
  coreutils,
  # for tests only
  rc-9front,
  runCommand,
  nawk,
}:

stdenv.mkDerivation {
  pname = "rc-9front";
  version = "0-unstable-2025-06-14";

  src = fetchFrom9Front {
    domain = "shithub.us";
    owner = "cinap_lenrek";
    repo = "rc";
    rev = "3e907e648d7263c159c604dc51aa8ca5d5fcd7f8";
    hash = "sha256-XucMQXlGdMcs3piMKRgmQNhuirSQP9mKmXbfTWbuePg=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    byacc
    installShellFiles
  ];
  enableParallelBuilding = true;
  # Rc bootstraps the new $path by hardcoding a common list
  # of binary locations common to most POSIX-y systems.
  # On NixOS the average $PATH is a lot more involved and
  # as such the resulting environment that rcmain.unix dumps you
  # into is not particularly useful. This patch instead makes
  # rc bootstrap the new $path using the existing $PATH.
  postPatch = ''
    substituteInPlace ./rcmain.unix --replace-fail 'path=(. /bin /usr/bin /usr/local/bin)' 'path=`:{${coreutils}/bin/env echo -n $PATH}'
  '';
  makeFlags = [ "PREFIX=$(out)" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ rc
    installManPage rc.1
    mkdir -p $out/lib
    install -m644 rcmain.unix $out/lib/rcmain

    runHook postInstall
  '';

  passthru = {
    shellPath = "/bin/rc";
    updateScript = unstableGitUpdater { shallowClone = false; };
    tests = {
      simple = runCommand "rc-test" { } ''
        ${lib.getExe rc-9front} -c 'nl=`{echo} && \
          res=`$nl{for(i in `{seq 1 10}) echo $i} && \
          echo -n $res' >$out
        [ "$(wc -l $out | ${lib.getExe nawk} '{ print $1 }' )" = 10 ]
        [ "$(${lib.getExe nawk} '{ a=a+$1 } END{ print a }' < $out)" = "$((10+9+8+7+6+5+4+3+2+1))" ]
      '';
      path = runCommand "rc-path" { } ''
        PATH='${coreutils}/bin:/a:/b:/c' ${lib.getExe rc-9front} -c 'echo $path(2-)' >$out
        [ '/a /b /c' = "$(cat $out)" ]
      '';
    };
  };

  meta = {
    description = "9front shell";
    longDescription = "unix port of 9front rc";
    homepage = "http://shithub.us/cinap_lenrek/rc/HEAD/info.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moody ];
    mainProgram = "rc";
    platforms = lib.platforms.all;
  };
}
