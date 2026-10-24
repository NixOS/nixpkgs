{ pkgs, ... }:

let
  # `one` has one candidate (y/n prompt), `two` has two (numbered prompt).
  db = pkgs.runCommand "programs.sqlite" { nativeBuildInputs = [ pkgs.sqlite ]; } ''
    sqlite3 $out <<'EOF'
    CREATE TABLE Programs (
      name text not null,
      system text not null,
      package text not null,
      primary key (name, system, package)
    );
    INSERT INTO Programs VALUES
      ('one', 'test', 'pkg-a'),
      ('two', 'test', 'pkg-a'),
      ('two', 'test', 'pkg-b');
    EOF
  '';

  fakeNixShell = pkgs.writeShellScriptBin "nix-shell" ''
    echo "FAKE-NIX-SHELL $*"
  '';

  # cnf-answer pipe|pty KEYS PROGRAM types KEYS (printf %b) at the prompt. On a
  # pty the fifo stays open, so the only EOF is a typed Ctrl-D (\004); timeout
  # stops a looping prompt and head keeps its output out of the test driver.
  cnfAnswer = pkgs.writeShellScriptBin "cnf-answer" ''
    mode=$1 keys=$2 program=$3
    export NIX_SYSTEM=test NIX_AUTO_RUN=1 NIX_AUTO_RUN_INTERACTIVE=1
    export PATH=${fakeNixShell}/bin:$PATH
    case $mode in
      pipe)
        printf '%b' "$keys" | timeout 10 command-not-found "$program" 2>&1 | head -c 4096
        exit "''${PIPESTATUS[1]}"
        ;;
      pty)
        fifo=$(mktemp -u)
        mkfifo "$fifo"
        exec 3<>"$fifo"
        printf '%b' "$keys" >&3
        timeout 10 script -qec "command-not-found $program" /dev/null <"$fifo" 2>&1 | head -c 4096
        exit "''${PIPESTATUS[0]}"
        ;;
    esac
  '';
in
{
  name = "command-not-found-auto-run";

  nodes.machine = {
    programs.command-not-found = {
      enable = true;
      dbPath = db;
    };
    environment.systemPackages = [ cnfAnswer ];
  };

  testScript = /* python */ ''
    import shlex

    machine.wait_for_unit("multi-user.target")

    def answer(mode, keys, program, status, prompts, ran=None):
        with subtest(f"{mode}: {program} <- {keys}"):
            got, out = machine.execute(f"cnf-answer {mode} {shlex.quote(keys)} {program}")
            seen = out.count("confirm? [yn]") + out.count("Your choice")
            assert got == status, f"exit status {got}, expected {status}:\n{out}"
            assert seen == prompts, f"{seen} prompts, expected {prompts}:\n{out}"
            if ran is None:
                assert "FAKE-NIX-SHELL" not in out, f"ran something:\n{out}"
            else:
                assert f"FAKE-NIX-SHELL -p {ran} --run exec {program}" in out, out

    for mode in ["pipe", "pty"]:
        answer(mode, r"y\n", "one", 0, 1, ran="pkg-a")
        answer(mode, r"n\n", "one", 0, 1)
        answer(mode, r"x\nn\n", "one", 0, 2)
        answer(mode, r"2\n", "two", 0, 1, ran="pkg-b")
        answer(mode, r"0\nabc\n1\n", "two", 0, 3, ran="pkg-a")

    answer("pipe", r"", "one", 127, 1)
    answer("pipe", r"x\n", "one", 127, 2)
    answer("pipe", r"", "two", 127, 1)
    answer("pipe", r"0\n3\n", "two", 127, 3)
    answer("pty", r"\004", "one", 127, 1)
    answer("pty", r"x\n\004", "one", 127, 2)
    answer("pty", r"\004", "two", 127, 1)
    answer("pty", r"9\n\004", "two", 127, 2)
  '';
}
