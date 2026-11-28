{ linkFarm, fetchFromGitHub }:
linkFarm "lute-deps" [
  {
    name = "luau";
    path = fetchFromGitHub {
      owner = "luau-lang";
      repo = "luau";
      rev = "4ca11dbc3b31ddf27ee8ec1ab6c036676de9f240";
      hash = "sha256-nfXJ16zkw9snA6dByPbP+OntPC4qXq5DK9ZnN5pvV98=";
    };
  }
  {
    name = "uSockets";
    path = fetchFromGitHub {
      owner = "uNetworking";
      repo = "uSockets";
      rev = "833497e8e0988f7fd8d33cd4f6f36056c68d225d";
      hash = "sha256-ZlyY2X0aDdjfV0zjcecOLaozwp1crDibx6GBbUnDyAk=";
    };
  }
  {
    name = "uWebSockets";
    path = fetchFromGitHub {
      owner = "uNetworking";
      repo = "uWebSockets";
      rev = "c445faa38125bf782eed3fec97f83b4733c7fb91";
      hash = "sha256-BEArW6TILz1Z39rjkge1PTz3defKwgITO6nBpyS13b8=";
    };
  }
]
