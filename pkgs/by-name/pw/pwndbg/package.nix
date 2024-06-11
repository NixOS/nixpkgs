{ lib
, stdenv
, python3
, makeWrapper
, gdb
}:

let
  pwndbg-py = python3.pkgs.pwndbg;

  pythonPath = python3.pkgs.makePythonPath [ pwndbg-py ];

  binPath = lib.makeBinPath ([
    python3.pkgs.pwntools # ref: https://github.com/pwndbg/pwndbg/blob/2022.12.19/pwndbg/wrappers/checksec.py#L8
  ] ++ lib.optionals stdenv.isLinux [
    python3.pkgs.ropper # ref: https://github.com/pwndbg/pwndbg/blob/2022.12.19/pwndbg/commands/ropper.py#L30
    python3.pkgs.ropgadget # ref: https://github.com/pwndbg/pwndbg/blob/2022.12.19/pwndbg/commands/rop.py#L32
  ]);
in
stdenv.mkDerivation {
  pname = "pwndbg";
  version = lib.getVersion pwndbg-py;
  format = "other";

  inherit (pwndbg-py) src;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pwndbg
    cp gdbinit.py $out/share/pwndbg/gdbinit.py
    chmod +x $out/share/pwndbg/gdbinit.py
    # First line is a import from future, so we need to append our imports after that
    sed '2 i import sys, os
    3 i [sys.path.append(p) for p in "${pythonPath}".split(":")]
    4 i os.environ["PATH"] += ":${binPath}"' -i $out/share/pwndbg/gdbinit.py

    # Don't require an in-package venv
    touch $out/share/pwndbg/.skip-venv

    makeWrapper ${gdb}/bin/gdb $out/bin/pwndbg \
      --add-flags "-q -x $out/share/pwndbg/gdbinit.py"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # Check if pwndbg is installed correctly
    HOME=$TMPDIR LC_CTYPE=C.UTF-8 $out/bin/pwndbg -ex exit

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Exploit Development and Reverse Engineering with GDB Made Easy";
    mainProgram = "pwndbg";
    homepage = "https://github.com/pwndbg/pwndbg";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mic92 patryk4815 msanft ];
    # not supported on aarch64-darwin see: https://inbox.sourceware.org/gdb/3185c3b8-8a91-4beb-a5d5-9db6afb93713@Spark/
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
