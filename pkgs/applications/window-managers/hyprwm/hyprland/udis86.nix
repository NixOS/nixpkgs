{ udis86
, fetchFromGitHub
}:
udis86.overrideAttrs (old: {
  version = "unstable-2022-10-13";

  src = fetchFromGitHub {
    owner = "canihavesomecoffee";
    repo = "udis86";
    rev = "5336633af70f3917760a6d441ff02d93477b0c86";
    hash = "sha256-HifdUQPGsKQKQprByeIznvRLONdOXeolOsU5nkwIv3g=";
  };

  patches = [ ];
})
