{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "rake";
  gemdir = ./.;
  exes = [ "rake" ];

  passthru.updateScript = bundlerUpdateScript "rake";

<<<<<<< HEAD
  meta = {
    description = "Software task management and build automation tool";
    homepage = "https://github.com/ruby/rake";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [
      manveru
      nicknovitski
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Software task management and build automation tool";
    homepage = "https://github.com/ruby/rake";
    license = with licenses; mit;
    maintainers = with maintainers; [
      manveru
      nicknovitski
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "rake";
  };
}
