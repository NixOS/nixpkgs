{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomi";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = "gomi";
    tag = "v${version}";
    hash = "sha256-JTmbToVzxFEQLwGVvDKdgKA4dBn6O+L6hDQJvAvvdwA=";
  };

  vendorHash = "sha256-znyk+ffDUo1nOWeM5k/WE2EE9FVvLxXyM/dV8KUSioU=";

  subPackages = [ "." ];

  meta = {
    description = "Replacement for UNIX rm command";
    homepage = "https://github.com/b4b4r07/gomi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mimame
      ozkutuk
    ];
    mainProgram = "gomi";
  };
}
