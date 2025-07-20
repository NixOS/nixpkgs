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

  cargoHash = "sha256-Gqa2aA8jr6SZexa6EejYHv/aEYcm51qvEJSUm4m1AVc=";

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
