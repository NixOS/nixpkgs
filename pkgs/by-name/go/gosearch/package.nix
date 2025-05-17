{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gosearch";
  version = "0-unstable-2024-04-28";

  src = fetchFromGitHub {
    owner = "ibnaleem";
    repo = "gosearch";
    rev = "b7add6092295081c89d2537767ded26e4f7d671c";
    hash = "sha256-0J5khhztNA1fToNTQ9WT5DWvxZ5jEmyHcy/4Lti8ry8=";
  };
  subPackages = [ "." ];
  vendorHash = "sha256-b7K9gs/M2XEUUan6LVkSZnEHq1vnztKmg5e6ncEVzr4=";
  meta = {
    description = "Efficient and reliable OSINT tool designed for uncovering digital footprints";
    homepage = "https://github.com/ibnaleem/gosearch";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ martinhrvn ];
    mainProgram = "gosearch";
  };
}
