import ./make-test-python.nix ({ pkgs, ... }:

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
    start_all()

    machine.wait_for_unit("solr.service")
    machine.wait_for_open_port(8983)
    machine.succeed("curl --fail http://localhost:8983/solr/")

    # adapted from pkgs.solr/examples/films/README.txt
    machine.succeed("sudo -u solr solr create -c films")
    assert '"status":0' in machine.succeed(
        """
      curl http://localhost:8983/solr/films/schema -X POST -H 'Content-type:application/json' --data-binary '{
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
      }'
    """
    )
    machine.succeed(
        "sudo -u solr post -c films ${pkgs.solr}/example/films/films.json"
    )
    assert '"name":"Batman Begins"' in machine.succeed(
        "curl http://localhost:8983/solr/films/query?q=name:batman"
    )
  '';
})
