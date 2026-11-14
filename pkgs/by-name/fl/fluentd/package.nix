{
  lib,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
  nixosTests,
}:

bundlerEnv {
  inherit ruby;

  pname = "fluentd";
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "fluentd";
  passthru.tests.fluentd = nixosTests.fluentd;

  meta = {
    description = "Data collector";
    homepage = "https://www.fluentd.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nicknovitski
    ];
    platforms = lib.platforms.unix;
  };
}
