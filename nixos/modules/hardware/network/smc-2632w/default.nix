{lib, config, ...}:

{
  hardware = {
    pcmcia = {
      firmware = [ (lib.cleanSource ./firmware) ];
    };
  };
}
