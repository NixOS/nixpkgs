import ./make-test.nix ({ pkgs, ... }:

{
  name = "solr";
  meta.maintainers = [ pkgs.stdenv.lib.maintainers.aanderse ];

  machine =
    { config, pkgs, ... }:
    {
      # Ensure the virtual machine has enough memory for Solr to avoid the following error:
      #
      #   OpenJDK 64-Bit Server VM warning:
      #     INFO: os::commit_memory(0x00000000e8000000, 402653184, 0)
      #     failed; error='Cannot allocate memory' (errno=12)
      #
      #   There is insufficient memory for the Java Runtime Environment to continue.
      #   Native memory allocation (mmap) failed to map 402653184 bytes for committing reserved memory.
      virtualisation.memorySize = 2000;

      services.solr.enable = true;
    };

  testScript = ''
    startAll;

    $machine->waitForUnit('solr.service');
    $machine->waitForOpenPort('8983');
    $machine->succeed('curl --fail http://localhost:8983/solr/');

    # adapted from pkgs.solr/examples/films/README.txt
    $machine->succeed('sudo -u solr solr create -c films');
    $machine->succeed(q(curl http://localhost:8983/solr/films/schema -X POST -H 'Content-type:application/json' --data-binary '{
      "add-field" : {
        "name":"name",
        "type":"text_general",
        "multiValued":false,
        "stored":true
      },
      "add-field" : {
        "name":"initial_release_date",
        "type":"pdate",
        "stored":true
      }
    }')) =~ /"status":0/ or die;
    $machine->succeed('sudo -u solr post -c films ${pkgs.solr}/example/films/films.json');
    $machine->succeed('curl http://localhost:8983/solr/films/query?q=name:batman') =~ /"name":"Batman Begins"/ or die;
  '';
})
