{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libX11,
  libXinerama,
}:

let
  rpathLibs = [
    libXinerama
    libX11
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "leftwm";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    rev = "refs/tags/${version}";
    hash = "sha256-wn5DurPWFwSUtc5naEL4lBSQpKWTJkugpN9mKx+Ed2Y=";
  };

  cargoHash = "sha256-TylRxdpAVuGtZ3Lm8je6FZ0JUwetBi6mOGRoT2M3Jyk=";

  buildInputs = rpathLibs;

  postInstall = ''
    for p in $out/bin/left*; do
      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $p
    done

    install -D -m 0555 leftwm/doc/leftwm.1 $out/share/man/man1/leftwm.1
  '';

  dontPatchELF = true;

  meta = {
    description = "A tiling window manager for the adventurer";
    homepage = "https://github.com/leftwm/leftwm";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ yanganto ];
    changelog = "https://github.com/leftwm/leftwm/blob/${version}/CHANGELOG.md";
    mainProgram = "leftwm";
  };
}
