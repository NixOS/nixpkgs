{ lib, haskell, fetchFromGitHub }:

let
  name = "simplex-chat";
  compiler = "ghc96";
  hlib = haskell.lib;

  # helper to add git repo from simplex-chat org
  simplexGit = name: rev: sha: fetchFromGitHub {
    owner = "simplex-chat"; repo = name;
    rev = rev;
    sha256 = sha;
  };

  git_simplexmq = simplexGit "simplexmq"
    "757b7eec81341d8560a326deab303bb6fb6a26a3"
    "sha256-gDjuzkg8eDuXDeo8ebYHJ1oRzWsdM+sEQINs9P3tFk8=";
  git_hs-socks = simplexGit "hs-socks"
    "a30cc7a79a08d8108316094f8f2f82a0c5e1ac51"
    "sha256-aEgouR5om+yElV5efcsLi+4plvq7qimrOTOkd7LdWnk=";
  git_direct-sqlcipher = simplexGit "direct-sqlcipher"
    "f814ee68b16a9447fbb467ccc8f29bdd3546bfd9"
    "sha256-9/K1pnUnUTLj6OV5neQF6bDrQvtgi0a4VekJQuuGPE4=";
  git_sqlcipher-simple = simplexGit "sqlcipher-simple"
    "a46bd361a19376c5211f1058908fc0ae6bf42446"
    "sha256-9JV2odagCkUWUGEe8dWmqHfjcBmn6rf6FAEBhxo6Gfw=";
  git_aeson = simplexGit "aeson"
    "aab7b5a14d6c5ea64c64dcaee418de1bb00dcc2b"
    "sha256-OTuJENv5I+9bWy6crllDm1lhkncmye33SCiqh1Sb50s=";
  git_http2 = fetchFromGitHub {
    owner = "kazu-yamamoto";
    repo = "http2";
    rev = "f5525b755ff2418e6e6ecc69e877363b0d0bcaeb";
    sha256 = "sha256-ZiG0vBtm8FZW1Lpe6zJnBMkzfq0iiEtjShXudwgA3Ts=";
  };
  git_simplex-chat = simplexGit "simplex-chat"
    "eabe17a88ed0ac12a59445cbc0c688821013442d"
    "sha256-yzLKMlpSSrxsVvLwud+vJRGCI29drpZ8QtvLqhfi9fY=";

  haskellOverrides = self: super: {
    direct-sqlcipher = self.callCabal2nix "direct-sqlcipher" git_direct-sqlcipher {};
    sqlcipher-simple = hlib.dontCheck (self.callCabal2nix "sqlcipher-simple" git_sqlcipher-simple {});
    simplexmq = hlib.dontCheck (hlib.doJailbreak (self.callCabal2nix "simplexmq" git_simplexmq {}));
    cryptostore = hlib.dontCheck super.cryptostore;
    aeson = hlib.dontCheck (self.callCabal2nix "aeson" git_aeson {});
    aeson-pretty = super.aeson-pretty_0_8_10;
    vector = hlib.doJailbreak super.vector;
    attoparsec-aeson = super.attoparsec-aeson_2_2_0_1;
    http2 = self.callCabal2nix "http2" git_http2 {};
    socks = self.callCabal2nix "socks" git_hs-socks {};
    simplex-chat = self.callCabal2nix name git_simplex-chat {};
  };

  hp = haskell.packages."${compiler}".extend haskellOverrides;

  meta = {
    mainProgram = "simplex-chat";
    homepage = "https://simplex.chat";
    description = "Command line version of SimpleX Chat.";
    license = lib.licenses.agpl3;
    maintainers = [ lib.maintainers.eyeinsky ];
    platforms = [ "x86_64-linux" ];
  };

in (hlib.dontCheck (hlib.doJailbreak hp.simplex-chat)) // { inherit meta; }
