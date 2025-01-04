{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "firefly";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "Brum3ns";
    repo = "firefly";
    tag = "v${version}";
    hash = "sha256-hhZw7u4NX+BvapUZv0k2Xu/UOdL7Pt8Idjat4aJzvIk=";
  };

  vendorHash = "sha256-eeVj0nU+cs1cZNVvwu4LgtQkpddtyYAYS91ANHyOjcY=";

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # Test fails with invalid memory address or nil pointer dereference
    substituteInPlace tests/httpfilter_test.go \
      --replace-fail "Test_HttpFilter" "Skip_HttpFilter"
  '';

  meta = {
    description = "Black box fuzzer for web applications";
    homepage = "https://github.com/Brum3ns/firefly";
    # https://github.com/Brum3ns/firefly/issues/12
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "firefly";
  };
}
