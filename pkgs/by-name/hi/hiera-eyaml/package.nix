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

  meta = with lib; {
    description = "Per-value asymmetric encryption of sensitive data for Hiera";
    homepage = "https://github.com/voxpupuli/hiera-eyaml";
    license = licenses.mit;
    maintainers = with maintainers; [
      benley
      nicknovitski
    ];
    platforms = platforms.unix;
    mainProgram = "eyaml";
  };
}
