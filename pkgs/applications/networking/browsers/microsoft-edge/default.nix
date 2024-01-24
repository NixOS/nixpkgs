{
  stable = import ./browser.nix {
    channel = "stable";
    version = "120.0.2210.144";
    revision = "1";
    hash = "sha256-O/7LdopcMfSYx8cg9BNDU6KxbPfnF9rYXD7Q6jugBLU=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "121.0.2277.71";
    revision = "1";
    hash = "sha256-PsfUZJ5ftHxSFGaXjzFMEff7Czfq88yL31mqNkFilNM=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "122.0.2348.0";
    revision = "1";
    hash = "sha256-Vsnrc43d70fLDncMeQeYhZJhnYex2LsIV1U2KPlkP9U=";
  };
}
