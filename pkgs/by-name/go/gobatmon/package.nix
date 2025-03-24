{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gobatmon";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ulinja";
    repo = "gobatmon";
    tag = "v${version}";
    hash = "sha256-morcsU9RhY17XlaDC6J0uDRYiSYjnXquFjuOh7AEKkA=";
  };

  vendorHash = "sha256-WUTGAYigUjuZLHO1YpVhFSWpvULDZfGMfOXZQqVYAfs=";

  meta = {
    description = "Simple battery level monitor for Linux written in Go";
    homepage = "https://github.com/ulinja/gobatmon";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ ulinja ];
    mainProgram = "gobatmon";
    downloadPage = "https://github.com/ulinja/gobatmon/releases/latest";
    changelog = "https://github.com/ulinja/gobatmon/blob/v${version}/CHANGELOG.md";
    platforms = lib.platforms.linux;
  };
}
