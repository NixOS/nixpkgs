import ./make-test.nix ({ pkgs, lib, ... }:

let
  produce = pkgs.writeScript "produce.py" ''
    #!${pkgs.python2.withPackages (p: [p.beanstalkc])}/bin/python
    import beanstalkc

    queue = beanstalkc.Connection(host='localhost', port=11300, parse_yaml=False);
    queue.put('this is a job')
    queue.put('this is another job')
  '';

  consume = pkgs.writeScript "consume.py" ''
    #!${pkgs.python2.withPackages (p: [p.beanstalkc])}/bin/python
    import beanstalkc

    queue = beanstalkc.Connection(host='localhost', port=11300, parse_yaml=False);

    job = queue.reserve(timeout=0)
    print job.body
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
