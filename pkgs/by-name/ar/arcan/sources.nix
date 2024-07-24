{
  fetchFromGitHub,
}:

{
  letoram-arcan = let
    self = {
      pname = "arcan";
      version = "0.6.3";

      src = fetchFromGitHub {
        owner = "letoram";
        repo = "arcan";
        rev = self.version;
        hash = "sha256-ZSKOkNrFa2QgmXmmXnLkB1pehmVJbEFVeNs43Z2DSKo=";
      };
    };
  in
    self;

  letoram-openal = {
    pname = "letoram-openal";
    version = "0.6.2";

    src = fetchFromGitHub {
      owner = "letoram";
      repo = "openal";
      rev = "81e1b364339b6aa2b183f39fc16c55eb5857e97a";
      hash = "sha256-X3C3TDZPiOhdZdpApC4h4KeBiWFMxkFsmE3gQ1Rz420=";
    };
  };

  libuvc = {
    pname = "libuvc";
    version = "0.0.7-unstable-2024-03-05";

    src = fetchFromGitHub {
      owner = "libuvc";
      repo = "libuvc";
      rev = "047920bcdfb1dac42424c90de5cc77dfc9fba04d";
      hash = "sha256-Ds4N9ezdO44eBszushQVvK0SUVDwxGkUty386VGqbT0=";
    };
  };

  luajit = {
    pname = "luajit";
    version = "2.1-unstable-2024-04-19";

    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "9b5e837ac2dfdc0638830c048a47ca9378c504d3";
      hash = "sha256-GflF/sELSNanc9G4WMzoOadUBOFSs6OwqhAXa4sudWA=";
    };
  };

  tracy = {
    pname = "tracy";
    version = "0.9.1-unstable-2023-10-09";

    src = fetchFromGitHub {
      owner = "wolfpld";
      repo = "tracy";
      rev = "93537dff336e0796b01262e8271e4d63bf39f195";
      hash = "sha256-FNB2zTbwk8hMNmhofz9GMts7dvH9phBRVIdgVjRcyQM=";
    };
  };

  letoram-tracy = {
    pname = "letoram-tracy";
    version = "0-unstable-2024-04-12";

    src = fetchFromGitHub {
      owner = "letoram";
      repo = "tracy";
      rev = "5b3513d9838317bfc0e72344b94aa4443943c2fd";
      hash = "sha256-hUdYC4ziQ7V7T7k99MERp81F5mPHzFtPFrqReWsTjOQ=";
    };
  };
}
