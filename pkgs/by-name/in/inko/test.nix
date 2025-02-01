{
  inko,
  writeText,
  runCommand,
  ...
}:

let
  source =
    writeText "hello.inko" # inko
      ''
        import std.process (sleep)
        import std.stdio (STDOUT)
        import std.time (Duration)

        class async Printer {
          fn async print(message: String, channel: Channel[Nil]) {
            let _ = STDOUT.new.print(message)

            channel.send(nil)
          }
        }

        class async Main {
          fn async main {
            let channel = Channel.new(size: 2)

            Printer().print('Hello', channel)
            Printer().print('world', channel)

            channel.receive
            channel.receive
          }
        }
      '';
in

runCommand "inko-test" { } ''
  ${inko}/bin/inko run ${source} > $out
  cat $out | grep -q Hello
  cat $out | grep -q world
''
