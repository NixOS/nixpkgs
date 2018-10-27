{ config, stdenv, ... }:

{
  config = with stdenv.lib; {
    udev = {
      package = {
        type = types.package;
        
      };
    };
  };
}
