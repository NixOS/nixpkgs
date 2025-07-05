{
  stdenv,
}:
{
  # test based on bootstrap tools to prevent rebuilding stdenv on each change
  parallel =
    (derivation {
      name = "test-parallel-hook";
      system = stdenv.system;
      builder = "${stdenv.bootstrapTools}/bin/bash";
      PATH = "${stdenv.bootstrapTools}/bin";
      args = [
        "-c"
        ''
          . ${../parallel.sh}
          . ${./test-parallel.sh}
        ''
      ];
    })
    // {
      meta = { };
    };
}
