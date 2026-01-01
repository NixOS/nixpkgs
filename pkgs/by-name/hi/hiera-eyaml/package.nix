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

<<<<<<< HEAD
  meta = {
    description = "Per-value asymmetric encryption of sensitive data for Hiera";
    homepage = "https://github.com/voxpupuli/hiera-eyaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      benley
      nicknovitski
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Per-value asymmetric encryption of sensitive data for Hiera";
    homepage = "https://github.com/voxpupuli/hiera-eyaml";
    license = licenses.mit;
    maintainers = with maintainers; [
      benley
      nicknovitski
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "eyaml";
  };
}
