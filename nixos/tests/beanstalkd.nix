import ./make-test.nix ({ pkgs, lib, ... }:

let
  pythonEnv = pkgs.python3.withPackages (p: [p.beanstalkc]);

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

  machine =
    { ... }:
    { services.beanstalkd.enable = true;
    };

  testScript = ''
    startAll;

    $machine->waitForUnit('beanstalkd.service');

    $machine->succeed("${produce}");
    $machine->succeed("${consume}") eq "this is a job\n" or die;
    $machine->succeed("${consume}") eq "this is another job\n" or die;
  '';
})
