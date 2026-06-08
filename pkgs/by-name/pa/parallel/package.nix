{
  fetchurl,
  lib,
  stdenv,
  perl,
  makeWrapper,
  procps,
  coreutils,
  gawk,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parallel";
  version = "20260422";

  src = fetchurl {
    url = "mirror://gnu/parallel/parallel-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ZkzxZdZuohey9JzZanhl7PkMnQYWWZzCq6jK1IHZB7s=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  strictDeps = true;
  nativeBuildInputs = [
    makeWrapper
    perl
  ];
  buildInputs = [
    perl
    procps
  ];

  postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace Makefile.in \
      --replace '$(DESTDIR)$(bindir)/parallel --shell-completion' '${lib.getExe buildPackages.parallel} --shell-completion'
  '';

  preInstall = ''
    patchShebangs ./src/parallel
  '';

  postInstall = ''
    wrapProgram $out/bin/parallel \
      --prefix PATH : "${
        lib.makeBinPath [
          procps
          perl
          coreutils
          gawk
        ]
      }"
  '';

  # Force run `check` instead of the `tests` target, because the `test` target depends on a private testsuite.
  # The reason `check` isn't used by default is due to it failing when selecting the target to run. (due to stdenv not overriding the Makefiles SHELL variable from `/bin/bash`).
  #
  # See:
  #   https://github.com/NixOS/nixpkgs/blob/ef4f672aa2be8b268a4280e8e2a68cd97a4cf67b/pkgs/stdenv/generic/setup.sh#L1541
  #   https://github.com/NixOS/nixpkgs/blob/ef4f672aa2be8b268a4280e8e2a68cd97a4cf67b/pkgs/stdenv/generic/setup.sh#L1555
  checkTarget = "check";
  doCheck = true;

  meta = {
    description = "Shell tool for executing jobs in parallel";
    longDescription = ''
      GNU Parallel is a shell tool for executing jobs in parallel.  A job
      is typically a single command or a small script that has to be run
      for each of the lines in the input.  The typical input is a list of
      files, a list of hosts, a list of users, or a list of tables.

      If you use xargs today you will find GNU Parallel very easy to use.
      If you write loops in shell, you will find GNU Parallel may be able
      to replace most of the loops and make them run faster by running
      jobs in parallel.  If you use ppss or pexec you will find GNU
      Parallel will often make the command easier to read.

      GNU Parallel makes sure output from the commands is the same output
      as you would get had you run the commands sequentially.  This makes
      it possible to use output from GNU Parallel as input for other
      programs.
    '';
    homepage = "https://www.gnu.org/software/parallel/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      pSub
      tomberek
    ];
    mainProgram = "parallel";
  };
})
