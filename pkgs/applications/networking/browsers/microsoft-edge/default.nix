{
  stable = import ./browser.nix {
    channel = "stable";
    version = "121.0.2277.83";
    revision = "1";
    hash = "sha256-WuDu44elNlkYZEtol+TZNpcRAkAq8HHATYCc9Or/bvU=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "121.0.2277.83";
    revision = "1";
    hash = "sha256-eW8Bpcjw1aY5lMqsGCJ3hORVLhzW8Fmaio+kpSOzPeU=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "122.0.2353.0";
    revision = "1";
    hash = "sha256-llLaq13SU4ZpqhOYK0hy6ZD6amAqijStk8TIHX3gydQ=";
  };
}
