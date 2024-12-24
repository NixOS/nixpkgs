{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, testers
, writeText
, runCommand
, jj
}:
buildGoModule rec {
  pname = "jj";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = "jj";
    rev = "v${version}";
    hash = "sha256-Yijap5ZghTBe1ahkQgjjxuo++SriJWXgRqrNXIVQ0os=";
  };

  vendorHash = "sha256-39rA3jMGYhsh1nrGzI1vfHZzZDy4O6ooYWB8af654mM=";

  subPackages = [ "cmd/jj" ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = with testers; {
      version = testVersion { package = jj; };
      examples = testEqualContents {
        assertion = "examples from projects README.md work";
        actual = runCommand "actual" { nativeBuildInputs = [ jj ]; } ''
          {
            echo '{"name":{"first":"Tom","last":"Smith"}}' | jj name.last
            echo '{"name":{"first":"Tom","last":"Smith"}}' | jj name
            echo '{"name":{"first":"Tom","last":"Smith"}}' | jj -v Andy name.first
            echo '{"friends":["Tom","Jane","Carol"]}' | jj -v Andy friends.-1
            echo '{"age":46,"name":{"first":"Tom","last":"Smith"}}' | jj -D age
          } > $out
        '';
        expected = writeText "expected" ''
          Smith
          {"first":"Tom","last":"Smith"}
          {"name":{"first":"Andy","last":"Smith"}}
          {"friends":["Tom","Jane","Carol","Andy"]}
          {"name":{"first":"Tom","last":"Smith"}}
        '';
      };
    };
  };

  meta = with lib; {
    description = "JSON Stream Editor (command line utility)";
    longDescription = ''
      JJ is a command line utility that provides a fast and simple way to retrieve
      or update values from JSON documents. It's powered by GJSON and SJSON under the hood.
      It's fast because it avoids parsing irrelevant sections of json, skipping over values
      that do not apply, and aborts as soon as the target value has been found or updated.
    '';
    homepage = "https://github.com/tidwall/jj";
    changelog = "https://github.com/tidwall/jj/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "jj";
    maintainers = with maintainers; [ katexochen ];
  };
}
