{
  lib,
  bash,
  fetchFromGitHub,
  installShellFiles,
  coreutils,
  gawk,
  gnugrep,
  gnused,
  openssh,
  resholve,
  rsync,
  which,
  zfs,
}:

resholve.mkDerivation rec {
  pname = "zxfer";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "allanjude";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-11SQJcD3GqPYBIgaycyKkc62/diVKPuuj2Or97j+NZY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  # these may point to paths on remote systems, calculated at runtime, thus we cannot fix them
  # we can only set their initial values, and let them remain dynamic
  postPatch = ''
    substituteInPlace zxfer \
      --replace 'LCAT=""'                'LCAT=${coreutils}/bin/cat' \
      --replace 'LZFS=$( which zfs )'    'LZFS=${zfs}/bin/zfs'
  '';

  installPhase = ''
    runHook preInstall

    installManPage zxfer.1m zxfer.8
    install -Dm755 zxfer -t $out/bin/

    runHook postInstall
  '';

  solutions.default = {
    scripts = [ "bin/zxfer" ];
    interpreter = "${bash}/bin/sh";
    inputs = [
      coreutils
      gawk
      gnugrep
      gnused
      openssh
      rsync
      which
    ];
    fake.external = [
      "kldload" # bsd builtin
      "kldstat" # bsd builtin
      "svcadm" # solaris builtin
    ];
    keep = {
      "$LCAT" = true;
      "$LZFS" = true;
      "$PROGRESS_DIALOG" = true;
      "$RZFS" = true;
      "$input_optionts" = true;
      "$option_O" = true;
      "$option_T" = true;
    };
    fix = {
      "$AWK" = [ "awk" ];
      "$RSYNC" = [ "rsync" ];
    };
    execer = [ "cannot:${rsync}/bin/rsync" ];
  };

  meta = with lib; {
    description = "A popular script for managing ZFS snapshot replication";
    homepage = "https://github.com/allanjude/zxfer";
    changelog = "https://github.com/allanjude/zxfer/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with lib.maintainers; [ urandom ];
    mainProgram = "zxfer";
  };
}
