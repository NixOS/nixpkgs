{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_13,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "colorstorm";
  # last tagged release is three years old and requires outdated Zig 0.9
  # new release requested in: https://github.com/benbusby/colorstorm/issues/16
  version = "2.0.0-unstable-2025-01-17";

  src = fetchFromGitHub {
    owner = "benbusby";
    repo = "colorstorm";
    rev = "e645c4293fb5f72968038dac99e0b8dab3db194f";
    hash = "sha256-6D+aNcjJksv7E9RJB9fnzgzvGoUPXV4Shz5wLu5YHtg=";
  };

  patches = [
    # Fixes a use-after-free segfault.
    # See https://github.com/benbusby/colorstorm/pull/15#discussion_r1930406581
    # and upstream PR https://github.com/NixOS/nixpkgs/pull/377279
    ./0001-fix-segfault.patch
  ];

  nativeBuildInputs = [
    zig_0_13.hook
  ];

  meta = {
    description = "Color theme generator for editors and terminal emulators";
    homepage = "https://github.com/benbusby/colorstorm";
    license = lib.licenses.mit;
    maintainers = [ ];
    inherit (zig_0_13.meta) platforms;
    mainProgram = "colorstorm";
  };
})
