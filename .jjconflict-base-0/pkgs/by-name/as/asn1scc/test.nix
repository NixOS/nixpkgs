# Compiles a simple ASN.1 file and checks whether the output is valid C.
{
  runCommand,
  gcc,
  asn1scc,
  writeText,
}:
let
  asn1File = writeText "foo.asn1" ''
    FooProtocol DEFINITIONS ::= BEGIN
      FooQuestion ::= SEQUENCE {
        id   INTEGER,
        ack  BOOLEAN
      }

      FooAnswer ::= SEQUENCE {
        id  INTEGER,
        ack BOOLEAN
      }

    END
  '';
in
runCommand "asn1scc-test-run"
  {
    nativeBuildInputs = [
      asn1scc
      gcc
    ];
  }
  ''
    asn1scc --c-lang ${asn1File}
    gcc -c asn1crt.c
    gcc -c *-foo.c
    touch $out
  ''
