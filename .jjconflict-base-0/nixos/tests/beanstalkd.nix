import ./make-test-python.nix (
  { pkgs, lib, ... }:

  let
    pythonEnv = pkgs.python3.withPackages (p: [ p.beanstalkc ]);

    produce = pkgs.writeScript "produce.py" ''
      #!${pythonEnv.interpreter}
      import beanstalkc

      queue = beanstalkc.Connection(host='localhost', port=11300, parse_yaml=False);
      queue.put(b'this is a job')
      queue.put(b'this is another job')
    '';

    consume = pkgs.writeScript "consume.py" ''
      #!${pythonEnv.interpreter}
      import beanstalkc

      queue = beanstalkc.Connection(host='localhost', port=11300, parse_yaml=False);

      job = queue.reserve(timeout=0)
      print(job.body.decode('utf-8'))
      job.delete()
    '';

  in
  {
    name = "beanstalkd";
    meta.maintainers = [ lib.maintainers.aanderse ];

    nodes.machine =
      { ... }:
      {
        services.beanstalkd.enable = true;
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("beanstalkd.service")

      machine.succeed("${produce}")
      assert "this is a job\n" == machine.succeed(
          "${consume}"
      )
      assert "this is another job\n" == machine.succeed(
          "${consume}"
      )
    '';
  }
)
