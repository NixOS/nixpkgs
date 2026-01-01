{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "redis-dump";
  gemdir = ./.;
  exes = [
    "redis-dump"
    "redis-load"
  ];

  passthru.updateScript = bundlerUpdateScript "redis-dump";

<<<<<<< HEAD
  meta = {
    description = "Backup and restore your Redis data to and from JSON";
    homepage = "https://delanotes.com/redis-dump/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Backup and restore your Redis data to and from JSON";
    homepage = "https://delanotes.com/redis-dump/";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      offline
      manveru
      nicknovitski
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
