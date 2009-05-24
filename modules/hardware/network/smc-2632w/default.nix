{pkgs, config, ...}:

{
  hardware = {
    pcmcia = {
      firmware = [ (pkgs.lib.cleanSource ./firmware) ];
    };
  };
}
