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
    version = "0.10-unstable-2024-05-08";

    src = fetchFromGitHub {
      owner = "wolfpld";
      repo = "tracy";
      rev = "11eee619fbb2ca97d8b7f7f6e0d6b20e37afbe61";
      hash = "sha256-VRRNL7trX9Q6x/ujByidlJQvHxtDe7NZ7JomLFzXDE0=";
    };
  };
}
