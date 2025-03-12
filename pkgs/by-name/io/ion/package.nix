{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage {
  pname = "ion";
  version = "unstable-2024-09-20";

  src = fetchFromGitLab {
    domain = "gitlab.redox-os.org";
    owner = "redox-os";
    repo = "ion";
    rev = "8acd140eeec76cd5efbd36f9ea8425763200a76b";
    hash = "sha256-jiJ5XW7S6/pVEOPYJKurolLI3UrOyuaEP/cqm1a0rIU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "calculate-0.7.0" = "sha256-3CI+7TZeW1sk6pBigxESK/E7G+G1/MniVIn4sqfk7+w=";
      "nix-0.23.1" = "sha256-yWJYrQt9piJHhqBkH/hn9dsXR8oqzl0RKPrzx9fvqlw=";
      "object-pool-0.5.3" = "sha256-LWP0b62sk2dcqnQEEvLmZVvWSVLJ722yH/zIIPL93W4=";
      "redox_liner-0.5.2" = "sha256-ZjVLACkyOT6jVRWyMj0ixJwCv6IjllCLHNTERlncIpk=";
      "small-0.1.0" = "sha256-QIzEfFc0EDEllf+YxVyV7j/PvC7nVWiK0YYBoZBQZ3Q=";
    };
  };

  patches = [
    # remove git revision from the build script to fix build
    ./build-script.patch
  ];

  passthru = {
    shellPath = "/bin/ion";
  };

  meta = with lib; {
    description = "Modern system shell with simple (and powerful) syntax";
    homepage = "https://gitlab.redox-os.org/redox-os/ion";
    license = licenses.mit;
    maintainers = with maintainers; [
      dywedir
      arthsmn
    ];
    mainProgram = "ion";
    platforms = platforms.unix;
  };
}
