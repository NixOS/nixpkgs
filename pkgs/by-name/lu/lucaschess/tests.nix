{
  lib,
  runCommand,
  lucaschess,
}:

runCommand "lucaschess-tests"
  {
    meta.timeout = 120;
  }
  ''
    export HOME=$TMPDIR LUCASCHESS_HOME=$TMPDIR/lucaschess PYTHONDONTWRITEBYTECODE=1

    # Only checks that the launcher starts LucasR.py, which exits before importing Code
    ${lib.getExe lucaschess} -healthcheck

    engines=${lucaschess}/share/lucaschess/bin/OS/linux/Engines
    for engine in irina/irina eguzki/eguzki eguzkilore/eguzkilore stockfish/stockfish; do
      if ! (printf 'uci\nisready\n'; sleep 2; echo quit) | timeout 20 $engines/$engine | grep -q readyok; then
        echo "$engine did not answer isready"
        exit 1
      fi
    done

    # isready comes before lc0 loads the weights, a move needs them
    if ! (cd $engines/maia && (printf 'uci\nsetoption name WeightsFile value maia-1100.pb.gz\nposition startpos\ngo nodes 1\n'; sleep 5; echo quit) | timeout 20 ./lc0 | grep -q '^bestmove'); then
      echo "maia did not play a move"
      exit 1
    fi

    # These would leak into the engines
    for var in PYTHONPATH PYTHONOPTIMIZE; do
      if grep -q "$var" ${lib.getExe lucaschess}; then
        echo "the launcher sets $var"
        exit 1
      fi
    done

    export QT_QPA_PLATFORM=offscreen
    cd ${lucaschess}/share/lucaschess/bin
    ${lucaschess.pythonEnv.interpreter} -O -c '
    import builtins, sys, types
    builtins._ = lambda s: s
    import Code, FasterCode, OSEngines
    import Code.Main.Init, Code.Procesador

    FasterCode.set_init_fen()
    if len(FasterCode.get_exmoves()) != 20:
        sys.exit("FasterCode: wrong number of legal moves from the start position")

    Code.configuration = types.SimpleNamespace(x_maia_nodes_exponential=False)
    keys = sorted(OSEngines.read_engines(Code.folder_engines))
    expected = ["eguzki", "eguzkilore", "irina"] + [f"maia-{n}" for n in (*range(1100, 2000, 100), 2200)] + ["stockfish"]
    if keys != expected:
        sys.exit(f"registered engines {keys}, expected {expected}")
    '

    touch $out
  ''
