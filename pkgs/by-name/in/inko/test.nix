{
  inko,
  writeText,
  runCommand,
  ...
}:

let
  source =
    # https://docs.inko-lang.org/manual/v0.19.1/getting-started/hello-concurrency/#channels
    writeText "hello.inko" # inko
      ''
        import std.process (sleep)
        import std.stdio (Stdout)
        import std.sync (Channel)
        import std.time (Duration)

        type async Printer {
          fn async print(message: String, channel: uni Channel[Nil]) {
            let _ = Stdout.new.print(message)

            channel.send(nil)
          }
        }

        type async Main {
          fn async main {
            let channel = Channel.new

            Printer().print('Hello', recover channel.clone)
            Printer().print('world', recover channel.clone)

            sleep(Duration.from_millis(500))

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
