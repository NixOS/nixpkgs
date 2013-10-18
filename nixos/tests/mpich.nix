# Simple example to showcase distributed tests using NixOS VMs.

{ pkgs, ... }:

with pkgs;

{
  nodes = {
    master =
      { config, pkgs, ... }: {
        environment.systemPackages = [ gcc mpich2 ];
        #boot.kernelPackages = pkgs.kernelPackages_2_6_29;
      };

    slave =
      { config, pkgs, ... }: {
        environment.systemPackages = [ gcc mpich2 ];
      };
  };

  # Start master/slave MPI daemons and compile/run a program that uses both
  # nodes.
  testScript =
    ''
       startAll;

       $master->succeed("echo 'MPD_SECRETWORD=secret' > /etc/mpd.conf");
       $master->succeed("chmod 600 /etc/mpd.conf");
       $master->succeed("mpd --daemon --ifhn=master --listenport=4444");

       $slave->succeed("echo 'MPD_SECRETWORD=secret' > /etc/mpd.conf");
       $slave->succeed("chmod 600 /etc/mpd.conf");
       $slave->succeed("mpd --daemon --host=master --port=4444");

       $master->succeed("mpicc -o example -Wall ${./mpich-example.c}");
       $slave->succeed("mpicc -o example -Wall ${./mpich-example.c}");

       $master->succeed("mpiexec -n 2 ./example >&2");
    '';
}
