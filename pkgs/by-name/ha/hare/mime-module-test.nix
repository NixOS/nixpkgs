{
  hare,
  runCommandNoCC,
  writeText,
}:
let
  mainDotHare = writeText "main.ha" ''
    use fmt;
    use mime;
    export fn main() void = {
        const ext = "json";
        match(mime::lookup_ext(ext)) {
        case let mime: const *mime::mimetype =>
          fmt::printfln("Found mimetype for extension `{}`: {}", ext, mime.mime)!;
        case null =>
          fmt::fatalf("Could not find mimetype for `{}`", ext);
        };
      };
  '';
in
runCommandNoCC "mime-module-test" { nativeBuildInputs = [ hare ]; } ''
  HARECACHE="$(mktemp -d)"
  export HARECACHE
  readonly binout="test-bin"
  hare build -qRo "$binout" ${mainDotHare}
  ./$binout
  : 1>$out
''
