{ fetchurl }:

rec {
  version = "0.12.5";
  src = fetchurl {
    url = "https://github.com/quassel/quassel/archive/${version}.tar.gz";
    sha256 = "04f42x87a4wkj3va3wnmj2jl7ikqqa7d7nmypqpqwalzpzk7kxwv";
  };
}
