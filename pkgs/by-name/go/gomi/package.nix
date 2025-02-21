{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomi";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = "gomi";
    tag = "v${version}";
    hash = "sha256-vUHMVyaUvMNCLUxPkR+Bk+As2A1W6ePyyuPv3SmM48Y=";
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
