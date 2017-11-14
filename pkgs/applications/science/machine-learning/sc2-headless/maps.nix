{ fetchzip
}:

{
  minigames = fetchzip {
    url = "https://github.com/deepmind/pysc2/releases/download/v1.2/mini_games.zip";
    sha256 = "19f873ilcdsf50g2v0s2zzmxil1bqncsk8nq99bzy87h0i7khkla";
    stripRoot = false;
  };

}
