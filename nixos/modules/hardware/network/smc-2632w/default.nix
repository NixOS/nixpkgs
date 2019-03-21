{lib, ...}:

{
  hardware = {
    pcmcia = {
      firmware = [ (lib.cleanSource ./firmware) ];
    };
  };
}
