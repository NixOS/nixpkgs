{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "lurk";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KiM5w0YPxEpJ4cR/8YfhWlTrffqf5Ak1eu0yxgOmqUs=";
  };

  cargoHash = "sha256-wccehO+zHKINMk9q7vZjUUl7puB6NzcYdl+meA5Bh/c=";

  postPatch = ''
    substituteInPlace src/lib.rs \
      --replace-fail '/usr/bin/ls' 'ls'
  '';

  meta = with lib; {
    description = "Simple and pretty alternative to strace";
    mainProgram = "lurk";
    homepage = "https://github.com/jakwai01/lurk";
    changelog = "https://github.com/jakwai01/lurk/releases/tag/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
