{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "duplicacy";
  version = "3.2.5";

  src = fetchFromGitHub {
    owner = "gilbertchen";
    repo = "duplicacy";
    rev = "v${version}";
    hash = "sha256-PS1vN5XkyihiiahIdzJmzdr1yyJMkzCpVbXgbZL2jHE=";
  };

  vendorHash = "sha256-4M/V4vP9XwHBkZ6UwsAxZ81YAzP4inuNC5yI+5ygQsA=";

  doCheck = false;

  meta = {
    homepage = "https://duplicacy.com";
    description = "New generation cloud backup tool";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      ffinkdevs
      devusb
    ];
  };
}
