{
  lib,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
}:

bundlerEnv {
  inherit ruby;
  pname = "hiera-eyaml";
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "hiera-eyaml";

  meta = {
    description = "Per-value asymmetric encryption of sensitive data for Hiera";
    homepage = "https://github.com/voxpupuli/hiera-eyaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      benley
      nicknovitski
    ];
    platforms = lib.platforms.unix;
    mainProgram = "eyaml";
  };
}
